module.exports =
  frontend: ({state, app}) ->
    @bootstrapKit = app.bootstrapKit
    {SidebarMenu, WebComponent, Pane} = @bootstrapKit

    @sideBarMenu = new SidebarMenu
      view: '.main-sidebar > section.sidebar > ul.sidebar-menu'

    @bootstrapKit.addPane('main-sidebar', @sideBarMenu)

    @contentPane = new Pane
      view: '.content-wrapper > section.content'

    @bootstrapKit.addPane('content', @contentPane)

    @bootstrapKit.addPane 'logo-mini', new WebComponent
      view: '.main-header > .logo > .logo-mini'

    @bootstrapKit.addPane 'logo-lg', new WebComponent
      view: '.main-header > .logo > .logo-lg'

    @bootstrapKit.addPane 'navbar-custom-menu', new WebComponent
      view: '.main-header > .navbar > .navbar-custom-menu > ul.navbar-nav'

    window.JSONEditor.defaults.options.theme = 'bootstrap3'
    window.JSONEditor.defaults.options.disable_edit_json = on
    window.JSONEditor.defaults.options.disable_properties = on

    @attachMenuToPane @contentPane, @sideBarMenu

    app.onDidActivatePackages =>
      if document.location.hash
        @bootstrapKit.trigger(document.location.hash[1...])

  attachMenuToPane: (pane, menu) ->
    pane.observeComponents (component, makeMenuItemView) =>

      makeView = makeMenuItemView or =>
        title = component.options?.title or "no title set for #{component}"
        name  = component.options?.name  or @bootstrapKit.slugify(title)

        @bootstrapKit.addTrigger name, ->
          current = pane.activateItem component


        """<a href="##{name}">#{title}</a>"""

      menuItem = new @bootstrapKit.MenuItem makeView(), ->
        current = pane.activateItem component

      pane.onDidActiveItemChange ({oldItem, newItem}) ->
        debugger
        oldItem?.menuItem.getView().classList.remove('active')
        newItem.menuItem.getView().classList.add('active')

      menu.addComponent menuItem
      component.menuItem = menuItem

      if component instanceof @bootstrapKit.Pane
        # upgrade the menuitem to be a dropdown treeview

        menuItemView = @bootstrapKit.getView(component)
        menuItemView.classList.add 'treeview'
        menuItemView.innerHTML += """<ul class="treeview-menu"></ul>"""

        element = menuItemView.querySelector 'treeview-menu'
        component.attachComponentView element, component

        @attachMenuToPane component, tree
