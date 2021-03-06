helpers = window.viewHelpers

class MockRequest extends MockClass
  @chainedCallback 'success'
  @chainedCallback 'error'

oldRequest = Batman.Request

QUnit.module 'Batman.View partial rendering',
  setup: ->
    MockRequest.reset()
    Batman.Request = MockRequest

  teardown: ->
    Batman.View.store = new Batman.HTMLStore
    Batman.Request = oldRequest

asyncTest "preloaded/already rendered partials should render", ->
  Batman.View.store =
    get: (k) ->
      equal k, '/test/one'
      "<div>Hello from a partial</div>"

  source = '<div data-partial="test/one"></div>'
  helpers.render source, {}, (node) ->
    delay =>
      lowerEqual node.children(0).html(), "Hello from a partial"

# FIXME
# asyncTest "unloaded partials should load then render", 2, ->
#   source = '<div data-partial="test/one"></div>'

#   # Callback below doesn't fire until view's ready event, which waits for the partial to be fetched and rendered.
#   helpers.render source, {}, (node) ->
#     lowerEqual node.children(0).html(), "<div>Hello from a partial</div>"
#     QUnit.start()

#   setTimeout ->
#     equal MockRequest.lastInstance.constructorArguments[0].url, "/assets/batman/html/test/one.html"
#     MockRequest.lastInstance.fireSuccess('<div>Hello from a partial</div>')
#   , ASYNC_TEST_DELAY

# asyncTest "unloaded partials should only load once", ->
#   source = '<div data-foreach-object="objects">
#               <div data-partial="test/one"></div>
#             </div>'

#   context = objects: new Batman.Set(1,2,3,4)

#   node = helpers.render source, context, (node) ->
#     delay ->
#       lowerEqual node.children(0).children(0).html(), "<div>Hello from a partial</div>"

#   doWhen (-> MockRequest.instanceCount > 0), ->
#     equal MockRequest.instanceCount, 1
#     MockRequest.lastInstance.fireSuccess('<div>Hello from a partial</div>')

# asyncTest "data-defineview bindings can be used to embed view contents", ->
#   source = '<div data-defineview="test/view">
#               <p data-bind="foo"></p>
#             </div>
#             <div>
#               <div data-partial="test/view"></div>
#             </div>'

#   node = helpers.render source, {foo: 'bar'}, (node) ->
#     equal node.length, 1
#     equal node.find('p').html(), 'bar'
#     QUnit.start()
