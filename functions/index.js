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

// This is for notifying the users of their respective transactions
// the transactions can be found through the bookings subcollection under listings collection, specifically listings/bookings/{bookingId}
// exports.notifyUserPaymentListing = functions.https.onRequest(async (req, res) =>  {
//   const notification = req.body.notification;

//   // extract the contents of notification
//   const notificationTitle = notification.notificationTitle;
//   const notificationMessage = notification.notificationMessage;
//   const userId = notification.userId;

//   // create the payload
//   const payload = {
//     notification: {
//       title: notificationTitle,
//       body: notificationMessage
//     }
//   };

//   const tokensCollection = await admin.firestore().collection('users').doc(userId).collection('tokens').get();

//   const tokens = tokensCollection.docs.map(doc => doc.data().token);

//   const message = {
//     notification: payload.notification,
//     tokens: tokens
//   };

//   return admin.messaging().sendMulticast(message)
//   .then((response) => {
//     console.log('Successfully sent message:', response);
//     console.log('Results:', response.responses);
//     res.status(200).send("Notification sent! This is the response and message tokens: " + response + " " + message.tokens);
//   }).catch((error) => {
//     console.log('Error sending message:', error);
//     res.status(500).send("Error sending message.  This is the error message: " + error);
//   });
// });

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


// comment out for a while, since there will be more changes for the notifications --> incorporation of a new page dedicated for notifications

// // this is to notify the user that they have a pending balance for their booking due to the downpayment rate
// // notify the user every day due to having a short downpayment period
// // exports.notifyUserPendingBalance = functions.https.onRequest(async (req, res) => {

// // });

// exports.notifyUserPendingBalance = functions.pubsub.schedule('every 24 hours').onRun(async (context) => {
//   // get the firestore database under listings/bookings
//   // on bookings, there are the following fields: 
//     // paymentOption, paymentStatus, amountPaid, totalPrice
//   // on listings, there are the following fields:
//     // downpaymentRate, duration, cancellationRate, cancellationPeriod
// });


// // this is to notify the user that they have cancelled their booking for the listing
// exports.notifyUserCancelledBooking = functions.https.onRequest(async (req, res) => { 
//   const userInfo = req.body.userInfo;
//   const bookingDetails = req.body.bookingDetails;
//   const listingDetails = req.body.listingDetails;

//   // extract the contents of userInfo
//   const userEmail = userInfo.email;
//   const userName = userInfo.name;
//   const userId = userInfo.userId ;

//   // extract the contents of bookingDetails
//   const bookingStartDate = bookingDetails.bookingStartDate;
//   const bookingEndDate = bookingDetails.bookingEndDate;
//   const amountPaid = bookingDetails.amountPaid;
//   const paymentOption = bookingDetails.paymentOption;
//   const paymentStatus = bookingDetails.paymentStatus;
//   const listingTitle = bookingDetails.listingTitle;

//   // extract the contents of listingDetails == important ones
//   const cancellationRate = listingDetails.cancellationRate;

//   // convert the cancellation rate to a numerical value
//   const cancellationRateNum = parseFloat(cancellationRate);

//   // calculate the refund amount
//   const refundAmount = amountPaid * cancellationRateNum;

//   // create the payload

//   const tokensCollection = await admin.firestore().collection('users').doc(userId).collection('tokens').get();

//   const tokens = tokensCollection.docs.map(doc => doc.data().token);

//   const message = {
//     notification: payload.notification,
//     tokens: tokens
//   };

//   return admin.messaging().sendMulticast(message).then((response) => {
//     console.log('Successfully sent message:', response);
//     res.status(200).send("Notification sent! This is the response: " + response);
//   }
//   ).catch((error) => {
//     console.log('Error sending message:', error);
//     res.status(500).send("Error sending message.  This is the error message: " + error);
//   });
// });

// // this is to notify the publisher that the user who booked their listing has cancelled their booking
// exports.notifyPublisherCancelledBooking = functions.https.onRequest(async (req, res) => {

// });

// // this is to notify cooperative users that have been assigned to the publisher's listing of their task/s
// exports.notifyCoopMemberTasks = functions.https.onRequest(async (req, res) => {

// });

// // this is to notify the users when there is chat activity in the chatroom
// exports.notifyChatActivity = functions.https.onRequest(async (req, res) => {

// });