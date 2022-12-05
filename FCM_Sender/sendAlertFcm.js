const admin = require("firebase-admin");
const { getMessaging } = require('firebase-admin/app');

const serviceAccount = require("./fcm_server_key.json");

const app = admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});

// This registration token comes from the client FCM SDKs.
const registrationToken = 'cyVxwJkqwkpou2uXOYTqmv:APA91bEeip1CeQ6allp6NVn2-WpuLMgxKY2WJxQeiYvvdvaBo-uuxw1aQba8152Bczkd62GnmZ8mX1qr1ydmCMgly2fMRXUjArU-G_fV1HzFel-otztzzp-7DdpdOzEqbceomKueNiYn';

const message = {
    notification: {
        title: 'FCM Title',
        body: 'FCM Notification body'
    },
    //   data: {
    //     score: '850',
    //     time: '2:45'
    //   },
    token: registrationToken
};

// Send a message to the device corresponding to the provided
// registration token.
app.messaging().send(message)
    .then((response) => {
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
    })
    .catch((error) => {
        console.log('Error sending message:', error);
    });