console.log 'script loaded'

$dieTemplate = $ '.template .die'
$roll = $ '#roll'

getRandomInt = ( min, max ) ->
  return Math.floor( Math.random() * ( max - min + 1 ) ) + min

Game = ( options ) ->
  @opts = options or {}
  @dice = [1..6].map ( val ) ->
    return new Die()
  return @

Game::render = ->
  @dice.forEach ( die, idx ) ->
    $slot = $ '.slot-' + idx
    return $slot.html die.render()
  return @

Game::roll = ->
  @dice.forEach ( die ) ->
    console.log die
    return die.roll()
  @render()
  return @

Die = ( options ) ->
  @opts = options or {}
  @value = @opts.value or getRandomInt 1, 6
  @wild = @makeWild()
  @held = false
  return @

Die::makeWild = ->
  random = getRandomInt 1, 8
  if random is 1
    return true
  else
    return false

Die::render = ->
  $die = $dieTemplate.clone()
  $die.on 'click', ( e ) ->
    return console.log e
  classAttr = 'number-' + @.value
  if @.held
    classAttr = classAttr + ' held'
  if @.wild
    classAttr = classAttr + ' wild'
  return $die.addClass classAttr

Die::roll = ->
  if @held is false
    @value = getRandomInt 1, 6
    if @wild is false
      @wild = @makeWild()
  return @

Die::hold = ->
  if held is false
    @held = true
  return @

Die::holdToggle = ->
  @held = !@held
  return @

_game = new Game()

_game.render()

$roll.on 'click', ( e ) ->
  return _game.roll()
