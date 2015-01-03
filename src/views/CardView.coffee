class window.CardView extends Backbone.View
  className: 'card'

  initialize: -> @render()

  render: ->
    @$el.children().detach()
    cardRank = @model.attributes.rankName
    cardSuit = @model.attributes.suitName.toLowerCase()
    @$el.addClass 'covered' unless @model.get 'revealed'
    if @$el.hasClass('covered')
      @$el.css('background-image', 'url(' + "img/card-back.png" + ')')
    else
      @$el.css('background-image', 'url(' + "img/cards/#{cardRank}-#{cardSuit}.png" + ')')
    @$el.css('background-size', 'cover')

