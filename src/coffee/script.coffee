$roll = $ '#roll'

getRandomInt = ( min, max ) ->
  return Math.floor( Math.random() * ( max - min + 1 ) ) + min

isWild = ->
  random = getRandomInt 1, 8
  if random is 1
    return true
  else
    return false

Die = Backbone.Model.extend
  defaults:
    held: false
    value: 1 # getRandomInt 1, 6
    wild: false # isWild()

Die::roll = ->
  if !@.get 'held'
    @.set 'value', getRandomInt 1, 6
    if !@.get 'wild'
      @.set 'wild', isWild()
  return @

Game = Backbone.Collection.extend
  model: Die

DieView = Backbone.View.extend
  # tagName: 'div'
  template: _.template $('#dieTemplate').html()
  initialize: ->
    this.render()
    return this
  render: ->
    this.$el.html this.template this.model.toJSON()
    if this.model.get 'held'
      this.$el.addClass('held')
    else
      this.$el.removeClass('held')
    return this
  events:
    'click': 'holdToggle'
    'roll': 'roll'
  holdToggle: ->
    held = this.model.get 'held'
    this.model.set 'held', !held
    this.render()
    return this

GameView = Backbone.View.extend
  el: '#container'
  initialize: ->
    this.render()
    return this
  render: ->
    this.$el.html ''
    this.collection.each ( die ) ->
      dieView = new DieView model: die, className: 'col-md-2'
      return this.$el.append dieView.el
    , this
    return this
  rollAll: ->
    this.collection.each ( die ) ->
      return die.roll()
    , this
    this.render()
    return this

dice = [1..5].map ( i ) ->
  return new Die
    value: getRandomInt 1, 6
    wild: isWild()

view = new GameView collection: new Game dice

$roll.on 'click', ( e ) ->
  return view.rollAll()
