const FCM = require('fcm-node');
const serverKey = require('./fcm_server_key.json');
const fcm = new FCM(serverKey);

const message = {
    to: 'erL3iZlFMEhQpM6W5W3Y85:APA91bHx7cNoymwAefZCYsbrryazLQK6y6lNr3tKfwqww4oS7TVePWntI3Zar_xrTx22VaNlW2XnndBblrcAyMHsc_74sNp-fOMvczZqLm17IBhVlR31p5HrKt0iqZRvYDb7lJ7WGduF', 
    // collapse_key: '1',
    
    notification: {
        title: 'Title of your push notification', 
        body: 'Body of your push notification' 
    },
    
    data: {  //you can send only notification or only data(or include both)
        my_key: 'my value',
        my_another_key: 'my another value'
    }
};

fcm.send(message, (err, res) => {
    if (err) {
        console.log("Something has gone wrong!", err);
    } else {
        console.log("Successfully sent with response: ", response);
    }
});