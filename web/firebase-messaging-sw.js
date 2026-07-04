importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyDLfwr7HUq_RfuciE-ORpHQ1uTqYbJrBoU',
  appId: '1:41028256496:web:374cf8b3f428b142',
  messagingSenderId: '41028256496',
  projectId: 'sooq-syria-787e6',
  storageBucket: 'sooq-syria-787e6.firebasestorage.app',
  authDomain: 'sooq-syria-787e6.firebaseapp.com',
});

const messaging = firebase.messaging();
