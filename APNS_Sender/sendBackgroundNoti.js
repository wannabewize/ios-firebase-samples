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
note.payload = {
    data: {
        results: [
            {
                opponent: "portugal",
                result: "win",
                score: "2-1"
            }
        ]        
    }
};
note.contentAvailable = true;

note.topic = 'xyz.wannabewize.codershigh.example.PushNotiExample';

const token = '8c5232bb2757f8820081835dd86c05b6e550ad0475bf94f531fb8d175bfb5d22';
               

apnProvider.send(note, token).then( ret => {
    console.log('result :', ret);
    if ( ret.failed ) {
        ret.failed.forEach( item => {
            console.log('failed :', item);
        })
    }
});