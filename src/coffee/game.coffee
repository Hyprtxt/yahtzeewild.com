$score     = $ '#score'
$turn      = $ '#turn'
$roll      = $ '#roll'

Game = ->
  @roll       = 0
  @turn       = 1
  @bonusTurns = 0
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
  @render()
  return @

Game::endTurn = ->
  @turn = @turn + 1
  # check turns for gameOver
  if ( @turn + @bonusTurns ) is 14
    alert 'Game over, you scored: ' + @getScore()
    _game = new Game()
  @roll = 0
  @bonusCheck()
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
  # if roll is 0, no score event listeners
  console.log @roll
  $score.text @getScore()
  $roll.text @roll
  $turn.text @turn
  return @
