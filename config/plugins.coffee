Path = require('path')

# This file is fed to server.require()

module.exports = [
  # static file serving
    register: require('inert')
  ,
  # view serving
    register: require('vision')
  ,
  # jade helper
    register: require('../plugins/jadeHelper')
  ,
  # event logging
    register: require('good')
    options:
      opsInterval: 1000
      reporters:[
        reporter: require('good-console')
        events:
          log: '*'
          response: '*'
      ,
        reporter: require('good-file')
        events:
          log: '*'
          response: '*'
        config: Path.join( __dirname, '../log', 'good.log' )
      ]
]
