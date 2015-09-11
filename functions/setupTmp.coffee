#setup
Path = require('path')
Mkdirp = require('mkdirp')
Touch = require('touch')

module.exports = ( cb ) ->
  # Create ./log/good.log if we need to
  Mkdirp Path.join( __dirname, '../log' ), ( err ) ->
    if (err)
      throw err
    else
      Touch Path.join( __dirname, '../log', 'good.log' ), {}, ( err ) ->
        if (err)
          throw err
        else
          if cb && typeof cb is 'function'
            cb()
