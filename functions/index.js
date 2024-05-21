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

admin.initializeApp();

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


