const apn = require('apn');

const option = {
    token: {
        key: 'AuthKey_YG887Y3FCC.p8',
        keyId: 'YG887Y3FCC',
        teamId: '4QG3GC35LA'
    },
}

const apnProvider = new apn.Provider(option);

let note = new apn.Notification();


// https://developer.apple.com/documentation/usernotifications/setting_up_a_remote_notification_server/generating_a_remote_notification#2943365
note.expiry = Math.floor(Date.now() / 1000) + 3600;
note.badge = 3;
note.sound = 'ping.aiff';
note.alert = {
    title : "You have a new message",
    body: "This is message body" 
};
// note.payload = {
//     data: {
//         results: [
//             {
//                 opponent: "portugal",
//                 result: "win",
//                 score: "2-1"
//             }
//         ]        
//     }
// };
// note.contentAvailable = true;
// note.mutableContent = true
note.topic = 'xyz.wannabewize.codershigh.example.PushNotiExample';

const token = '2c214ae8e1e5424b9abc1a97b9f3de3db23f3ba1108b6923bca49ff5f7700060';
               

apnProvider.send(note, token).then( ret => {
    console.log('result :', ret);
    if ( ret.failed ) {
        ret.failed.forEach( item => {
            console.log('failed :', item);
        })
    }
});