class window.AppView extends Backbone.View
  template: _.template '
    <button class="hit-button btn btn-primary btn-lg">Hit</button> <button class="stand-button btn btn-primary btn-lg">Stand</button>
    <div class="dealer-hand-container"></div>
    <div class="player-hand-container"></div>
  '

  events:
    'click .hit-button': -> @model.get('playerHand').hit()
    'click .stand-button': -> @model.get('playerHand').stand()

  initialize: ->
    @render()
    @model.on('newHand', @render, this)

  render: ->
    @$el.children().detach()
    @$el.html @template()
    @$('.player-hand-container').html new HandView(collection: @model.get 'playerHand').el
    @$('.dealer-hand-container').html new HandView(collection: @model.get 'dealerHand').el

