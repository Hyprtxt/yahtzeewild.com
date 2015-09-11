gulp = require('gulp')
gutil = require('gulp-util')
sass = require('gulp-sass')
sourcemaps = require('gulp-sourcemaps')
autoprefixer = require('gulp-autoprefixer')
coffee = require('gulp-coffee')
livereload = require('gulp-livereload')
rimraf = require('rimraf')
taskListing = require('gulp-task-listing')

gulp.task 'default', taskListing

gulp.task 'help', taskListing

gulp.task 'clean', ( cb ) ->
  rimraf './static_generated', cb

gulp.task 'sass', ->
  gulp.src './src/sass/**/*.sass'
    .pipe sourcemaps.init()
    .pipe sass(
        outputStyle: 'expanded'
        includePaths: ['./bower_components/bootstrap/scss']
      ).on 'error', sass.logError
    .pipe autoprefixer ['> 1%']
    .pipe sourcemaps.write '../map' # , sourceRoot: __dirname + './src'
    .pipe gulp.dest './static_generated/css'
    .pipe livereload()

gulp.task 'coffee', ->
  gulp.src './src/coffee/**/*.coffee'
    .pipe sourcemaps.init()
    .pipe coffee(
        bare: true
      ).on 'error', gutil.log
    .pipe sourcemaps.write '../map' # , sourceRoot: __dirname + './src'
    .pipe gulp.dest './static_generated/js'
    .pipe livereload()

gulp.task 'watch', ->
  livereload.listen
    basePath: './src'
    start: true
  gulp.watch './src/sass/**/*.sass', ['sass']
  gulp.watch './src/coffee/**/*.coffee', ['coffee']
