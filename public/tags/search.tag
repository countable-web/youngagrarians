
<search>
  
  <div class='search-box-map-wrap'>
    <input type="text" placeholder="Search - bees, soil, Okanagan, etc." name="q" class="search-box-map" onkeyup={ onquery }>
  </div>
  <div class='results-toggle toggle' onclick={ toggle_results }>
     <span if={!results_list}>list</span>
     <img if={results_list} src="/images/map.png">
  </div>

  <!--<div class='category-toggle toggle' onclick={ toggle_categories }>
    <div class='notification' if={ num_cats_showing() }>{ num_cats_showing() }</div>
    CATEGORY
  </div>
  <ul if={ showing } class='category-panel panel'>
    <li each={ key, value in categories } class='panel-item' value="{ key }" onclick={ oncategorize }>
      { key }
      <span if={ value.showing } class='on'>&#x2714;</span>
    </li>
  </ul>-->

  //this.categories = opts.categories;
  
  var controller = this
     ,query = opts.kwargs['q']
     //,category = opts.kwargs['c']
     ,active_tag = opts.kwargs['t']
     ,orig_listings
     ,showing=false;
  
  controller.results_list = false;

  toggle_results(){
    toggle_results_event();
  }

  var toggle_results_event = function(){
    var rl = document.querySelector('results');
    if (rl.className) {
      rl.className='';
      controller.update({results_list:false});
    } else {
      rl.className='show';
      controller.update({results_list:true});
    }
  }

  opts.on('toggle_results', toggle_results_event)

  function listing_visible(item)
  {
    if (active_tag) {
      var match_type = is_meta(active_tag) ? 'meta' : 'primary';
      return item.categories.filter( function(x){
        return x.name === active_tag || x[match_type].name === active_tag;
      }).length > 0;
    } else {
      return true;
    }
  }

  onquery(e){
    query = e.target.value;
    orig_listings = null; // clear listings cache to force a trip to server.
    filter_listings();
  }

  function update_hash(){
    var hash_parts = [];
    if (active_tag) hash_parts.push("t=" + encodeURIComponent(active_tag));
    if (query) hash_parts.push("q=" + query);
    set_kwargs();
    window.location.hash = "#" + hash_parts.join("&");
  }
  
  opts.on('update_tag_start', function(tag){
    active_tag = tag;
    update_hash();
  });

  opts.on('update_tag', function(tag){
    active_tag = tag;
    setTimeout(filter_listings, 1); // ensure items are loaded after all update_tag events are processed first.
  });

  function handle_load(){
    var l = orig_listings.filter( function(x){ return listing_visible( x ); } );
    opts.trigger('load', l, orig_listings.length > l.length );
  }

  function filter_listings(){
    opts.trigger('loading');
    if( !orig_listings )
    {
      var path = '/locations.json';
      if (is_embedded) path='/surrey.json';
      if (query) path += '?q=' + query;
      ajax().get( path ).then(function(response){
        response.forEach(function(listing){
          listing.dist = Math.abs((listing.latitude || 999) - 49.104430) + Math.abs((listing.longitude || 999) - -122.801094);
          listing.is_event = listing.categories.filter(function(c){
            return (c.primary ? c.primary.name : c.name) == 'Events';
            }).length
        });
        
        orig_listings = response;
        handle_load();
      });
    }
    else
    {
      handle_load();
    }
  }
  if (query) {
    controller.q.value = query;
  }

  setTimeout(function(){
    filter_listings();  
  })
  

</search>
