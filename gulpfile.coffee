gulp = require 'gulp'
gutil = require 'gulp-util'
sass = require 'gulp-sass'
sourcemaps = require 'gulp-sourcemaps'
autoprefixer = require 'gulp-autoprefixer'
coffee = require 'gulp-coffee'
livereload = require 'gulp-livereload'
rimraf = require 'rimraf'
list = require 'gulp-task-listing'

dest = './static_generated'

gulp.task 'default', [ 'watch' ]

gulp.task 'help', list

gulp.task 'clean', ( cb ) ->
  return rimraf dest, cb

gulp.task 'copystatic', ->
  return gulp.src './static/**'
    .pipe gulp.dest dest

gulp.task 'copyjs', ->
  gulp.src './bower_components/bootstrap/js/dist/*'
    .pipe gulp.dest dest + '/js/bootstrap'
  gulp.src './bower_components/underscore/**.js'
    .pipe gulp.dest dest + '/js/underscore'
  gulp.src './bower_components/backbone/**.js'
    .pipe gulp.dest dest + '/js/backbone'
  return gulp.src './bower_components/jquery/dist/*'
    .pipe gulp.dest dest + '/js/jquery'

gulp.task 'copycss', ->
  return

gulp.task 'copyfont', ->
  return gulp.src './bower_components/font-awesome/fonts/*'
    .pipe gulp.dest dest + '/fonts'

gulp.task 'sass', ->
  return gulp.src './src/sass/**/*.sass'
    .pipe sourcemaps.init()
    .pipe sass(
        outputStyle: 'expanded'
        includePaths: [ './bower_components/' ]
      ).on 'error', sass.logError
    .pipe autoprefixer [ '> 1%' ]
    .pipe sourcemaps.write '../map'
    .pipe gulp.dest dest + '/css'
    .pipe livereload()

gulp.task 'coffee', ->
  return gulp.src './src/coffee/**/*.coffee'
    .pipe sourcemaps.init()
    .pipe coffee(
        bare: true
      ).on 'error', gutil.log
    .pipe sourcemaps.write '../map'
    .pipe gulp.dest dest + '/js'
    .pipe livereload()

gulp.task 'reload', ->
  return livereload.reload()

gulp.task 'waitreload', ( cb ) ->
  # This one has to wait for nodemon to restart
  # require caches './view-data/global.coffee'
  # letting nodemon restart is a quick lazy fix
  return setTimeout ->
    return cb livereload.reload()
  , 1500

gulp.task 'watch', [ 'copystatic', 'copyfont', 'copycss', 'sass', 'copyjs', 'coffee' ], ->
  gulp.watch './src/sass/**/*.sass', [ 'sass' ]
  gulp.watch './src/coffee/**/*.coffee', [ 'coffee' ]
  gulp.watch './views/**/*.jade', [ 'reload' ]
  gulp.watch './static/**/*.*', [ 'copystatic', 'reload' ]
  gulp.watch './view-data/**', [ 'waitreload' ]
  gulp.watch './readme.md', [ 'reload' ]
  return livereload.listen
    basePath: './src'
    start: true
