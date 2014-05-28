
module.exports = {
  variants: {
    items: {
       keepNames: true,
     
      resize: {
        thumb: '210x150'
      }
      
    },

    gallery: {
      keepNames: true,
     
      resize: {
        thumb: '160x160'
      }
    }
  },

  storage: {
    Local: {
      path: '/tmp',
      mode: 0777
    },
    Rackspace: {
      username: 'USERNAME',
      apiKey: 'API_KEY',
      // authUrl: "https://lon.auth.api.rackspacecloud.com",
      container: 'CONTAINER'
    },
    S3: {
      key: 'AKIAJTIGKXNQVTRBU45A',
      secret: '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',
      bucket: 'votechat',
      uploadDirectory :'posts/'
     
      // set `secure: false` if you want to use buckets with characters like .
    }
  },

  debug: true
}
