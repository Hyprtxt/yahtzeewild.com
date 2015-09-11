Path = require('path')

module.exports =
  engines:
    jade: require('jade')
  path: Path.join( __dirname , '../views' )
  compileOptions:
    pretty: true
  isCached: false # For Dev Purposes
