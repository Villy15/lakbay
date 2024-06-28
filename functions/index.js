/* eslint-disable */
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

// GOOGLE CLOUD FUNCTIONS ARE PUT HERE

// TO CREATE A NEW FUNCTION:
  // 1. Create a new function as intended (e.g. exports.functionName = functions.https.onRequest((req, res) => { ... })
  // 2. Deploy the function by running 'firebase deploy --only functions:functionName'

  // OPTIONAL, BUT HIGHLY ENCOURAGED:
    // 3. Test the function by running 'firebase serve --only functions' and sending a request to the function's endpoint
    // 4. Check the function's logs by running 'firebase functions:log'
    // 5. To store variables in order to avoid hardcoding, use 'firebase functions:config:set key=value' and access it using 'functions.config().key'

// This is for sending emails to its respective users
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const nodemailer = require("nodemailer");
const cors = require("cors")({origin: true});
const {google} = require("googleapis");
const { topic } = require("firebase-functions/v1/pubsub");
const serviceAccountKey = JSON.parse(Buffer.from(functions.config().service_account.key, 'base64').toString());
const fetch = require('node-fetch');

const OAuth2 = google.auth.OAuth2;

const oauth2Client = new OAuth2(
    functions.config().gmail.client_id,
    functions.config().gmail.client_secret,
    "https://developers.google.com/oauthplayground",
);

oauth2Client.setCredentials({
  refresh_token: functions.config().gmail.refresh_token,
});

const accessToken = oauth2Client.getAccessToken();

const gmailEmail = functions.config().gmail.email;

admin.initializeApp(

  {credential: admin.credential.cert(serviceAccountKey)}
);

const smtpTransport = nodemailer.createTransport({
  service: "gmail",
  auth: {
    type: "OAuth2",
    user: gmailEmail,
    clientId: functions.config().gmail.client_id,
    clientSecret: functions.config().gmail.client_secret,
    refreshToken: functions.config().gmail.refresh_token,
    accessToken: accessToken,
  },
});

exports.sendEmail = functions.https.onRequest((req, res) => {
  cors(req, res, () => {
    if (req.method !== "POST") {
      res.status(400).send("Request not allowed");
    }
    const members = req.body.newMembers;
    const coop = req.body.coop;

    members.forEach(member => {
      const mailOptions = {
        from: gmailEmail,
        to: member.email,
        subject: "Welcome to Lakbay!",
        text: `Hello there! \n\n
                The ${coop} as partnered with Lakbay and its team for a better cooperative experience. \n\n
                To login, ke sure to use the following credentials: \n\n
                Email: ${member.email} \n
                Password: ${member.password} \n\n
                It is advised to reset your password 
                after logging in to avoid any security issues. \n\n
                If you have any questions or concerns, 
                please do not hesitate to contact us. \n\n
                Thank you for your cooperation and welcome to the Lakbay App! \n\n
                Best regards, \n
                  The Lakbay Team \n\n
                  This is an automated email, please do not reply to this email.`,
      };

      smtpTransport.sendMail(mailOptions, (error, info) => {
        if (error) {
          console.log(error);
          res.status(500).send("Error sending email");
        }
        else {
          console.log("Email sent: " + info.response); 
        }
      });
    });
  });
});

// this is to notify the publisher of the listing that a user has booked their listing. The notification can be sent
// via the app. when terminated or backgrounded, the notification will be sent via the notification tray
exports.notifyUsers = functions.https.onRequest(async (req, res) => {
  const notification = req.body.notification;

  // extract the contents of notification:
  const notificationTitle = notification.notificationTitle;
  const notificationMessage = notification.notificationMessage;
  const publisherId = notification.publisherId;

  // create the payload
  const payload = {
    notification: {
      title: notificationTitle,
      body: notificationMessage
    }
  };

  const tokensCollection = await admin.firestore().collection('users').doc(publisherId).collection('tokens').get();

  const tokens = tokensCollection.docs.map(doc => doc.data().token);

  const message = {
    notification: payload.notification,
    tokens: tokens
  }

  return admin.messaging().sendMulticast(message)
  .then((response) => {
    console.log('Successfully sent message:', response);
    res.status(200).send("Notification sent! This is the response: " + response);
  }).catch((error) => {
    console.log('Errosr sending message:', error);
    res.status(500).send("Error sending message.  This is the error message: " + error);
  })
});

exports.notifyUserPendingBalance = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
  const bookingsCollection = admin.firestore().collection('listings').doc('bookings').get();

  const bookings = bookingsCollection.docs.map(doc => doc.data());

  bookings.forEach(async booking => {
    const paymentOption = booking.paymentOption;
    const paymentStatus = booking.paymentStatus;
    const amountPaid = booking.amountPaid;
    const totalPrice = booking.totalPrice;

    const listingCollection = admin.firestore().collection('listings').doc(booking.listingId).get();

    const listing = listingCollection.docs.map(doc => doc.data());

    const downpaymentRate = listing.downpaymentRate;
    const duration = listing.duration;

    if (paymentOption === "Downpayment" && paymentStatus === "Pending") {
      const downpaymentRateNum = parseFloat(downpaymentRate);
      const downpaymentAmount = totalPrice * downpaymentRateNum;

      if (amountPaid < downpaymentAmount) {
        const userId = booking.userId;

        const notification = {
          notificationTitle: "Pending Balance",
          notificationMessage: "You have a pending balance for your booking. Please settle the downpayment amount within the given period to avoid any issues.",
          userId: userId
        }

        const payload = {
          notification: {
            title: notification.notificationTitle,
            body: notification.notificationMessage
          }
        };

        const tokensCollection = await admin.firestore().collection('users').doc(userId).collection('tokens').get();

        const tokens = tokensCollection.docs.map(doc => doc.data().token);

        const message = {
          notification: payload.notification,
          tokens: tokens
        };

        return admin.messaging().sendMulticast(message)
        .then((response) => {
          console.log('Successfully sent message:', response);
          console.log('Results:', response.responses);
          res.status(200).send("Notification sent! This is the response and message tokens: " + response + " " + message.tokens);
        }).catch((error) => {
          console.log('Error sending message:', error);
          res.status(500).send("Error sending message.  This is the error message: " + error);
        });
      }
    }
  });
});

// integration of PayMaya API for payment processing
// exports.payWithPaymaya = functions.https.onRequest(async (req, res) => {
//   const url = 'https://pg-sandbox.paymaya.com/payments/v1/payment-tokens';
//   const headers = {
//     'Content-Type': 'application/json',
//     'Authorization': 'Basic ' + functions.config().paymaya.secret_key
//   };

//   const body = JSON.stringify({
//     // payment details such as cardNumber, cardType, csv, expiryMonth, expiryYear, and totalAmount
//   });

//   const response = await axios.post(url, body, {headers: headers});

//   if (response.ok) {
//     const jsonResponse = await response.json();
//     const paymentToken = jsonResponse.paymentTokenId;
//     const redirectUrl = jsonResponse.redirectUrl;

//     // Send the paymentToken and redirectUrl back to the Flutter app
//     res.json({paymentToken, redirectUrl});  
//   }
//   else {
//     console.error('Request failed with status: ', response.status);
//     res.status(500).send('Failed to create payment token.');
//   }

  
// });


// PayMaya API with checkout 
exports.payWithPaymayaCheckout = functions.https.onRequest(async (req, res) => {
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    res.status(204).send('');
    res.end();
    return;
  }
  
  const url = 'https://pg-sandbox.paymaya.com/checkout/v1/checkouts';
  const secretKey = functions.config().paymaya.public_key;
  const encodedSecretKey = Buffer.from(secretKey + ":").toString('base64');
  const headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Basic ' + encodedSecretKey
  };

  const payment = req.body.payment;
  const card = req.body.card;
  const userDetails = req.body.userDetails;
  const listingDetails = req.body.listingDetails;
  const redirectUrls = req.body.redirectUrls;

  // extract the payment details
  const totalPrice = payment.totalPrice;
  const paymentOption = payment.paymentOption;

  // extract the user details
  const [firstName, lastName] = userDetails.name.split(' ');
  const phoneNumber = userDetails.phone;

  // extract the card details
  const cardNumber = card.cardNumber;
  const expiryMonth = card.expiryMonth;
  const expiryYear = card.expiryYear;
  const cvv = card.cvv;

  // extract the listing details
  const listingName = listingDetails.listingTitle;
  

  const body = JSON.stringify({
    // payment details such as totalAmount, buyer, items, and redirectUrl
    authorizationType: "NORMAL",
    totalAmount: {
      value: parseFloat(totalPrice).toFixed(2),
      currency: 'PHP',
      details: { discount: 0, serviceCharge: 0, shippingFee: 0, tax: 0, subtotal: totalPrice }
    },
    buyer: {
      firstName: firstName,
      lastName: lastName,
      contact: {
        phone: phoneNumber
      }
    },
    items: [{
      name: listingName,
      quantity: 1,
      totalAmount: {
        value: parseFloat(totalPrice).toFixed(2),
        details: { discount: 0, unitPrice: totalPrice }
      }
    }],

    redirectUrl: {
      success: redirectUrls.success,
      failure: redirectUrls.failure,
      cancel: redirectUrls.cancel
    },
    requestReferenceNumber: listingDetails.listingId
  });

  console.log('Request Headers:', headers);
  console.log('Request Body:', body);

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: headers,
      body: body
    });

    const data = await response.json();
    console.log('Success:', data);
    
    if (data.checkoutId) {
      // redirect the user to the PayMaya payment page
      res.status(200).json({statusCode: 303, redirectUrl: data.redirectUrl});
    }
    else {
      console.error('Error:', data);
      res.status(500).send('Failed to create checkout. Here is the data: ' + JSON.stringify(data));
    }
  } catch (e) {
    console.error('Error:', e);
    res.status(500).send('Failed to create checkout. Error: ' + e);
  }

});
