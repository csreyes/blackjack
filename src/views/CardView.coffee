class window.CardView extends Backbone.View
  className: 'card'

  initialize: -> @render()

  render: ->
    @$el.children().detach()
    cardRank = @model.attributes.rankName
    cardSuit = @model.attributes.suitName.toLowerCase()
    @$el.css('background-image', 'url(' + "img/cards/#{cardRank}-#{cardSuit}.png" + ')')
    @$el.css('background-size', 'cover')
    @$el.addClass 'covered' unless @model.get 'revealed'

