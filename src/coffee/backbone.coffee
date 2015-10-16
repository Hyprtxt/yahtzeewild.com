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
    if this.model.get 'active'
      this.$el.removeClass 'hidden'
    else
      this.$el.addClass 'hidden'
    if this.model.get 'wild'
      this.$el.addClass 'wild'
    return this
  events:
    'click': 'toggleDie'
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
    _enableScores()
    return this
  endTurn: ->
    this.collection.forEach ( die ) ->
      die.set 'held', false
      die.set 'active', false
      return
    this.render()
    return this
