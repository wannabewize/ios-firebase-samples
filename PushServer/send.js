const apn = require('apn');

const option = {
    token: {
        key: 'AuthKey_G288QMCQTC.p8',
        keyId: 'G288QMCQTC',
        teamId: '4QG3GC35LA'
    },
}

const apnProvider = new apn.Provider(option);

let note = new apn.Notification();

note.expiry = Math.floor(Date.now() / 1000) + 3600;
note.badge = 3;
note.sound = 'ping.aiff';
note.alert = "\uD83D\uDCE7 \u2709 You have a new message";
note.payload = {
    title: 'APNS Test',
    messageFrom: 'John Appleseed'
};
note.topic = 'xyz.wannabewize.codershigh.example.PushNotiExample';

const token = 'ed016fd1ba18b6390adbdf428512fb648f3fffb5c0f78c12e9d09e993952118b';
               

apnProvider.send(note, token).then( ret => {
    console.log('result :', ret);
    if ( ret.failed ) {
        ret.failed.forEach( item => {
            console.log('failed :', item);
        })
    }
});