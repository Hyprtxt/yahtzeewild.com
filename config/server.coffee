Path = require('path')

module.exports =
  connections:
    routes:
      files:
        relativeTo: Path.join( __dirname, '../static' )
      files:
        relativeTo: Path.join( __dirname, '../static_generated' )
