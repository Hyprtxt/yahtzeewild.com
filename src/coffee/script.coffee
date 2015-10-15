$rollDice  = $ '#rollDice'
$score = $ '#score'
$turn  = $ '#turn'
$roll  = $ '#roll'

wildFactor = 8
started = false

getRandomInt = ( min, max ) ->
  return Math.floor( Math.random() * ( max - min + 1 ) ) + min

isWild = ->
  random = getRandomInt 1, wildFactor
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
      iswild = isWild()
      if iswild
        @.set 'wild', true
        @.set 'held', true
  return @

dice = [1..5].map ( i ) ->
  bewild = isWild()
  beheld = false
  if bewild
    beheld = true
  return new Die
    value: getRandomInt 1, 6
    wild: bewild
    held: beheld

Game = ->
  @roll       = 0
  @turn       = 1 # start at 0?
  @top1       = 0
  @top1Done   = false
  @top2       = 0
  @top2Done   = false
  @top3       = 0
  @top3Done   = false
  @top4       = 0
  @top4Done   = false
  @top5       = 0
  @top5Done   = false
  @top6       = 0
  @top6Done   = false
  @bonus      = 0
  @kind3      = 0
  @kind3Done  = false
  @kind4      = 0
  @kind4Done  = false
  @house      = 0
  @houseDone  = false
  @small      = 0
  @smallDone  = false
  @large      = 0
  @largeDone  = false
  @chance     = 0
  @chanceDone = false
  @kind5      = 0
  @kind5Done  = false
  @wild       = 0
  # @score    = 0
  return @

Game::endTurn = ->
  @turn = @turn + 1
  @roll = 0
  @bonusCheck()
  # unhold all dice
  _view.endTurn()
  @render()
  return @

Game::bonusCheck = ->
  total = @top1 + @top2 + @top3 + @top4 + @top5 + @top6
  if total > 62
    @bonus = 35
  return @

Game::getScore = ->
  return @top1 + @top2 + @top3 + @top4 + @top5 + @top6 + @bonus +
  @kind3 + @kind4 + @house + @small + @large + @chance + @kind5 + @wild

Game::render = ->
  # check turns for gameOver
  console.log @roll
  $score.text @getScore()
  $roll.text @roll
  $turn.text @turn
  return @

_game = new Game()
_game.render()

diceValues = ->
  return _view.collection.models.map ( die ) ->
    return die.get 'value'

scoreTop = ( val ) ->
  console.log diceValues()
  return diceValues().reduce ( prev, curr, idx, arr ) ->
    console.log curr, val
    if curr is val
      return prev + curr
    else
      return prev
  , 0

$('.top').on 'click', ( e ) ->
  $current = $( e.currentTarget )
  $current.attr 'disabled', true
  int = $current.data 'top'
  console.log scoreTop int
  _game[ 'top' + int + 'Done' ] = true
  _game[ 'top' + int ] = scoreTop int
  _game.endTurn()
  return

$('.kind3').on 'click', ( e ) ->
  $( e.currentTarget ).attr 'disabled', true
  _game.kind3Done = true
  return

$('.kind4').on 'click', ( e ) ->
  $( e.currentTarget ).attr 'disabled', true
  _game.kind4Done = true
  return

$('.house').on 'click', ( e ) ->
  $( e.currentTarget ).attr 'disabled', true
  _game.houseDone = true
  return

$('.small').on 'click', ( e ) ->
  $( e.currentTarget ).attr 'disabled', true
  _game.smallDone = true
  return

$('.large').on 'click', ( e ) ->
  $( e.currentTarget ).attr 'disabled', true
  _game.largeDone = true
  return

$('.chance').on 'click', ( e ) ->
  $( e.currentTarget ).attr 'disabled', true
  _game.chanceDone = true
  return

$('.yahtzee').on 'click', ( e ) ->
  $( e.currentTarget ).attr 'disabled', true
  _game.yahtzeeDone = true
  return

DiceCollection = Backbone.Collection.extend
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
      this.$el.addClass 'held'
    else
      this.$el.removeClass 'held'
    if this.model.get 'wild'
      this.$el.addClass 'wild'
      # this.$el.addClass 'held'
    return this
  events:
    'click': 'toggleDie'
    'roll': 'roll'
  toggleDie: ->
    wild = this.model.get 'wild'
    held = this.model.get 'held'
    value = this.model.get 'value'
    if !wild
      this.model.set 'held', !held
    else
      this.model.set 'held', true
      if value is 6
        this.model.set 'value', 1
      else
        this.model.set 'value', value + 1
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
  endTurn: ->
    this.collection.forEach ( die ) ->
      die.set 'held', false
      return
    this.render()
    return this

_view = {}

$rollDice.on 'click', ( e ) ->
  if !started
    _view = new GameView collection: new DiceCollection dice
  _game.roll++
  if _game.roll < 4
    _game.render()
    return _view.rollAll()
  else
    return alert 'nope, take a score'
