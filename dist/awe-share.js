(function() {
  var assert, callbackCache, counterCache, log,
    bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  if (!this.Maslosoft) {
    this.Maslosoft = {};
  }

  assert = function(expr) {
    if (!console) {
      return;
    }
    return console.assert(expr);
  };

  log = function(expr) {
    if (!console) {
      return;
    }
    return console.log(expx);
  };

  this.Maslosoft.AweShare = (function() {
    AweShare.idCounter = 0;

    AweShare.prototype.element = '';

    AweShare.prototype.adapters = {};

    AweShare.prototype.windows = {};

    function AweShare(element, data) {
      if (element == null) {
        element = null;
      }
      if (data == null) {
        data = null;
      }
      this.share = bind(this.share, this);
      this.dispose = bind(this.dispose, this);
      this.init = bind(this.init, this);
      if (element !== null) {
        this.init(element, data);
      }
    }

    AweShare.prototype.init = function(element, data) {
      var adapter, adapterName, i, index, len, meta, name, ref, ref1, ref2, tag, window;
      if (data == null) {
        data = null;
      }
      this.adapters = {};
      this.windows = {};
      this.element = {};
      AweShare.idCounter++;
      this.element = jQuery(element);
      if (!this.element.attr('id')) {
        this.element.attr('id', "maslosoft-awe-share-" + AweShare.idCounter);
      }
      if (data === null) {
        data = this.element.data();
      }
      meta = new Maslosoft.AweShare.Meta;
      if (typeof data.services === 'string') {
        data.services = data.services.replace(/\s*/g, '').split(',');
      }
      if (typeof data.services === 'undefined') {
        data.services = [];
      }
      if (!data.url) {
        data.url = '';
      }
      if (!data.title) {
        data.title = document.title;
      }
      if (!data.description) {
        data.description = meta.getName('description');
      }
      if (!data.tags) {
        data.tags = meta.getName('keywords');
      }
      console.log(meta.getName('keywords'));
      if (data.tags && typeof data.tags.split === 'function') {
        data.tags = data.tags.split(',');
        ref = data.tags;
        for (index = i = 0, len = ref.length; i < len; index = ++i) {
          tag = ref[index];
          data.tags[index] = tag.replace('#', '');
        }
      }
      if (!data.tags) {
        data.tags = [];
      }
      if (data.tags.constructor.name.toLowerCase() !== 'array') {
        data.tags = [];
      }
      console.log(data.tags);
      if (!data.image) {
        data.image = meta.getProperty('og:image');
      }
      if (data.counter === void 0) {
        data.counter = true;
      }
      if (data.counterEmpty === void 0) {
        data.counterEmpty = '';
      }
      if (data.tip === void 0) {
        data.tip = false;
      }
      if (!data.services.length) {
        ref1 = Maslosoft.AweShare.Adapters;
        for (name in ref1) {
          adapter = ref1[name];
          data.services.push(this.decamelize(name));
        }
      }
      this.adapters = {};
      ref2 = data.services;
      for (index in ref2) {
        name = ref2[index];
        adapterName = this.camelize(name);
        if (typeof Maslosoft.AweShare.Adapters[adapterName] === 'function') {
          adapter = new Maslosoft.AweShare.Adapters[adapterName];
          adapter.setUrl(data.url);
          if (adapter.setData) {
            adapter.setData(data);
          }
          window = new Maslosoft.AweShare.Window(data);
          this.adapters[name] = adapter;
          this.windows[name] = window;
        } else {
          console.warn("No adapter for " + name + " in ", element, (new Error).stack);
          data.services.splice(index, 1);
        }
      }
      if (this.adapters.length === 0) {
        console.warn("No adapters selected for ", element, (new Error).stack);
      }
      this.element.on('click', 'a', this.share);
      return new Maslosoft.AweShare.Renderer(this, data, this.adapters);
    };

    AweShare.prototype.dispose = function() {
      if (!this.element) {
        return;
      }
      this.element.off('click', 'a', this.share);
      return this.element.html('');
    };

    AweShare.prototype.share = function(e) {
      var adapter, clearUrl, data, service, window;
      data = jQuery(e.currentTarget).data();
      service = data.service;
      adapter = this.adapters[service];
      window = this.windows[service];
      clearUrl = false;
      if (!adapter.url) {
        adapter.url = document.location;
        clearUrl = true;
      }
      adapter.decorate(window);
      window.open();
      if (clearUrl) {
        adapter.url = '';
      }
      return e.preventDefault();
    };

    AweShare.prototype.decamelize = function(text, sep) {
      if (sep == null) {
        sep = '-';
      }
      return text.replace(/([a-z\d])([A-Z])/g, '$1' + sep + '$2').replace(new RegExp('(' + sep + '[A-Z])([A-Z])', 'g'), '$1' + sep + '$2').toLowerCase();
    };

    AweShare.prototype.camelize = function(text) {
      return text.replace(/(?:^|[-_])(\w)/g, function(_, c) {
        if (c) {
          return c.toUpperCase();
        } else {
          return '';
        }
      });
    };

    AweShare.init = function() {
      return jQuery('.awe-share').each(function(id, element) {
        return new window.Maslosoft.AweShare(element);
      });
    };

    return AweShare;

  })();

  this.Maslosoft.AweShare.Adapters = {};

  this.Maslosoft.AweShare.Adapter = (function() {
    function Adapter() {}

    Adapter.prototype.id = null;

    Adapter.prototype.url = '';

    Adapter.prototype.image = '';

    Adapter.prototype.data = null;

    Adapter.prototype.count = function(callback) {
      return callback(0);
    };

    Adapter.prototype.decorate = function(window) {
      return window.url = '#not implemented';
    };

    Adapter.prototype.setId = function(id1) {
      this.id = id1;
    };

    Adapter.prototype.getId = function() {
      return this.id;
    };

    Adapter.prototype.setImage = function(image) {
      this.image = image;
    };

    Adapter.prototype.setData = function(data1) {
      this.data = data1;
    };

    Adapter.prototype.setUrl = function(url) {
      url = url.toString();
      if (url.indexOf("#")) {
        return this.url = url.split("#")[0];
      } else {
        return this.url = url;
      }
    };

    return Adapter;

  })();

  counterCache = {};

  callbackCache = {};

  this.Maslosoft.AweShare.Counter = (function() {
    Counter.prototype.adapter = {};

    Counter.prototype.name = '';

    Counter.prototype.callback = {};

    function Counter(name1, adapter, callback) {
      this.name = name1;
      this.setCount = bind(this.setCount, this);
      this.count = bind(this.count, this);
      this.adapter = {};
      this.callback = {};
      this.adapter = adapter;
      this.callback = callback;
    }

    Counter.prototype.count = function() {
      if (counterCache[this.name] && typeof counterCache[this.name][this.adapter.url] === 'number') {
        return this.callback(this.name, counterCache[this.name][this.adapter.url]);
      } else {
        if (!counterCache[this.name]) {
          counterCache[this.name] = {};
        }
        if (!callbackCache[this.name]) {
          callbackCache[this.name] = {};
        }
        if (!callbackCache[this.name][this.adapter.url]) {
          this.adapter.count(this.setCount);
          return callbackCache[this.name][this.adapter.url] = [];
        } else {
          return callbackCache[this.name][this.adapter.url].push(this.callback);
        }
      }
    };

    Counter.prototype.setCount = function(number) {
      var callback, i, len, ref, results;
      counterCache[this.name][this.adapter.url] = parseInt(number);
      this.callback(this.name, parseInt(number));
      if (callbackCache[this.name] && callbackCache[this.name][this.adapter.url]) {
        ref = callbackCache[this.name][this.adapter.url];
        results = [];
        for (i = 0, len = ref.length; i < len; i++) {
          callback = ref[i];
          results.push(callback(this.name, parseInt(number)));
        }
        return results;
      }
    };

    return Counter;

  })();

  this.Maslosoft.AweShare.Meta = (function() {
    function Meta() {}

    Meta.prototype.getName = function(value) {
      return this.get('name', value);
    };

    Meta.prototype.getProperty = function(value) {
      return this.get('property', value);
    };

    Meta.prototype.get = function(type, value) {
      var attr, i, len, meta, ref;
      ref = document.getElementsByTagName('meta');
      for (i = 0, len = ref.length; i < len; i++) {
        meta = ref[i];
        attr = null;
        if (meta) {
          attr = meta.getAttribute(type);
        }
        if (attr && attr.toLowerCase() === value.toLowerCase()) {
          return meta.getAttribute('content');
        }
      }
      return '';
    };

    return Meta;

  })();

  this.Maslosoft.AweShare.Renderer = (function() {
    Renderer.prototype.sharer = {};

    Renderer.prototype.data = {};

    Renderer.prototype.adapters = {};

    Renderer.prototype.empty = '';

    Renderer.prototype.window = null;

    function Renderer(sharer, data, adapters) {
      this.setCounter = bind(this.setCounter, this);
      this.onScroll = bind(this.onScroll, this);
      var adapter, id, name, placement, ref, selector;
      this.sharer = {};
      this.adapters = {};
      this.data = {};
      this.sharer = sharer;
      this.data = data;
      this.adapters = adapters;
      this.empty = this.data.counterEmpty;
      this.window = jQuery(window);
      this.sharer.element.html('');
      if (typeof this.data.pin === 'number') {
        this.data.pinTop = this.data.pin;
      }
      if (typeof this.data.pinScroll === 'undefined') {
        this.data.pinScroll = this.data.pinTop;
      }
      if (this.data.pinTop) {
        this.sharer.element.addClass('awe-share-pin');
        if (!this.data.pinPosition || this.data.pinPosition === 'left') {
          this.sharer.element.addClass('awe-share-pin-left');
        }
        if (this.data.pinPosition === 'right') {
          this.sharer.element.addClass('awe-share-pin-right');
        }
        this.onScroll();
        if (this.data.pinScroll !== this.data.pinTop) {
          jQuery(window).scroll(this.onScroll);
        }
      }
      if (this.data.tip && typeof jQuery.fn.tooltip === 'function') {
        placement = 'top';
        if (this.sharer.element.hasClass('awe-share-pin-left')) {
          placement = 'right';
        }
        if (this.sharer.element.hasClass('awe-share-pin-right')) {
          placement = 'left';
        }
        if (typeof this.data.tip === 'string') {
          placement = this.data.tip;
        }
        id = this.sharer.element.attr('id');
        selector = " a";
        jQuery("#" + id).tooltip({
          selector: 'a',
          placement: placement
        });
      }
      ref = this.adapters;
      for (name in ref) {
        adapter = ref[name];
        this.render(name, adapter);
      }
    }

    Renderer.prototype.onScroll = function() {
      var top;
      top = this.window.scrollTop();
      if (top + this.data.pinScroll < this.data.pinTop) {
        this.sharer.element.css({
          top: this.data.pinTop - top
        });
      } else {
        this.sharer.element.css({
          top: this.data.pinScroll
        });
      }
    };

    Renderer.prototype.render = function(name, adapter) {
      var adapterName, counter, label, link, window;
      window = this.sharer.windows[name];
      adapterName = this.sharer.camelize(name);
      label = Maslosoft.AweShare.Adapters[adapterName].label;
      link = jQuery("<a href=\"" + window.url + "\" data-service=\"" + name + "\" class=\"awe-share-button awe-share-brand-" + name + "\" title=\"" + label + "\">\n	<i class='awe-share-button-icon fa fa-2x fa-" + name + "'></i>\n</a>");
      this.sharer.element.append(link);
      if (this.data.counter) {
        link.append("<span class=\"awe-share-counter\">" + this.empty + "</span>");
        counter = new Maslosoft.AweShare.Counter(name, adapter, this.setCounter);
        return counter.count();
      }
    };

    Renderer.prototype.humanize = function(count) {
      var thresh, u, units;
      count = parseInt(count);
      thresh = 1000;
      if (Math.abs(count) < thresh) {
        return count;
      }
      units = ['k', 'm', 'g'];
      u = -1;
      while (true) {
        count /= thresh;
        ++u;
        if (!(Math.abs(count) >= thresh && u < units.length - 1)) {
          break;
        }
      }
      return count.toFixed() + units[u];
    };

    Renderer.prototype.setCounter = function(name, value) {
      value = this.humanize(value);
      if (value === 0) {
        value = this.empty;
      }
      return this.sharer.element.find("a[data-service=" + name + "]").find('.awe-share-counter').html(value);
    };

    return Renderer;

  })();

  this.Maslosoft.AweShare.Window = (function() {
    Window.prototype.name = 'maslosoft-awe-share';

    Window.prototype.menubar = 0;

    Window.prototype.resizable = 1;

    Window.prototype.scrollbars = 0;

    Window.prototype.status = 0;

    Window.prototype.toolbar = 0;

    Window.prototype.top = '';

    Window.prototype.left = '';

    Window.prototype.width = '';

    Window.prototype.height = '';

    Window.prototype.url = '';

    Window.prototype.title = '';

    Window.prototype.description = '';

    function Window(data) {
      this.open = bind(this.open, this);
      this.title = data.title;
      this.description = data.description;
    }

    Window.prototype.open = function() {
      var h, i, len, name, ref, specs, value, w;
      w = screen.width || window.outerWidth;
      h = screen.height || window.outerHeight;
      if (this.width === '') {
        this.width = Math.ceil(w / 2);
      }
      this.width = Math.min(this.width, w);
      if (this.height === '') {
        this.height = Math.ceil(h / 2);
      }
      this.height = Math.min(this.height, h);
      if (this.top === '') {
        this.top = Math.ceil(h / 2) - Math.ceil(this.height / 2);
      }
      if (this.left === '') {
        this.left = Math.ceil(w / 2) - Math.ceil(this.width / 2);
      }
      specs = [];
      ref = ['menubar', 'resizable', 'scrollbars', 'status', 'toolbar', 'top', 'left', 'width', 'height'];
      for (i = 0, len = ref.length; i < len; i++) {
        name = ref[i];
        value = this[name];
        if (value !== '') {
          specs.push(name + "=" + value);
        }
      }
      return window.open(this.url, this.name, specs.join(','));
    };

    return Window;

  })();

  this.Maslosoft.AweShare.Adapters.Digg = (function(superClass) {
    extend(Digg, superClass);

    function Digg() {
      return Digg.__super__.constructor.apply(this, arguments);
    }

    Digg.label = "Submit to Digg";

    Digg.prototype.count = function(callback) {
      return $.getJSON("http://services.digg.com/1.0/endpoint?method=story.getAll&link=" + this.url + "&type=javascript&callback=?", (function(_this) {
        return function(data) {
          var shares;
          shares = 0;
          if (data.stories && data.stories[0] && data.stories[0].diggs) {
            shares = data.stories[0].diggs;
          }
          return callback(shares);
        };
      })(this)).fail(function() {
        return callback(0);
      });
    };

    Digg.prototype.decorate = function(window) {
      window.url = "http://digg.com/submit?url=" + this.url;
      window.width = 600;
      return window.height = 500;
    };

    return Digg;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Facebook = (function(superClass) {
    extend(Facebook, superClass);

    function Facebook() {
      return Facebook.__super__.constructor.apply(this, arguments);
    }

    Facebook.label = "Share on Facebook";

    Facebook.prototype.count = function(callback) {
      return $.getJSON("http://graph.facebook.com/?callback=?&ids=" + this.url, (function(_this) {
        return function(data) {
          var shares;
          if (!data[_this.url]) {
            data[_this.url] = {};
          }
          shares = data[_this.url].shares || 0;
          return callback(shares);
        };
      })(this)).fail(function() {
        return callback(0);
      });
    };

    Facebook.prototype.decorate = function(window) {
      window.url = "http://www.facebook.com/sharer.php?m2w&s=100&p[url]=" + this.url + "&p[title]=" + window.title + "&p[summary]=" + window.description + "&p[images][0]=" + this.image;
      window.width = 550;
      return window.height = 359;
    };

    return Facebook;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Linkedin = (function(superClass) {
    extend(Linkedin, superClass);

    function Linkedin() {
      return Linkedin.__super__.constructor.apply(this, arguments);
    }

    Linkedin.label = "Share on Linkedin";

    Linkedin.prototype.count = function(callback) {
      return $.getJSON("http://www.linkedin.com/countserv/count/share?callback=?&url=" + this.url, (function(_this) {
        return function(data) {
          var shares;
          shares = data.count;
          return callback(shares);
        };
      })(this)).fail(function() {
        return callback(0);
      });
    };

    Linkedin.prototype.decorate = function(window) {
      window.url = "http://www.linkedin.com/shareArticle?mini=true&url=" + this.url + "&title=" + window.title;
      window.width = 600;
      return window.height = 600;
    };

    return Linkedin;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Odnoklassniki = (function(superClass) {
    extend(Odnoklassniki, superClass);

    function Odnoklassniki() {
      return Odnoklassniki.__super__.constructor.apply(this, arguments);
    }

    Odnoklassniki.label = "Share on Odnoklassniki.ru";

    Odnoklassniki.prototype.count = function(callback) {
      $.getScript("http://www.odnoklassniki.ru/dk?st.cmd=extLike&ref=" + this.url).fail(function() {
        return callback(0);
      });
      if (!window.ODKL) {
        window.ODKL = {};
      }
      return window.ODKL.updateCount = (function(_this) {
        return function(id, shares) {
          return callback(shares);
        };
      })(this);
    };

    Odnoklassniki.prototype.decorate = function(window) {
      window.url = "http://www.odnoklassniki.ru/dk?st.cmd=addShare&st._surl=" + this.url + "&title=" + window.title;
      window.width = 600;
      return window.height = 500;
    };

    return Odnoklassniki;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Pinterest = (function(superClass) {
    extend(Pinterest, superClass);

    function Pinterest() {
      return Pinterest.__super__.constructor.apply(this, arguments);
    }

    Pinterest.label = "Pin It";

    Pinterest.prototype.count = function(callback) {
      return $.getJSON("http://api.pinterest.com/v1/urls/count.json?callback=?&url=" + this.url, function(data) {
        var shares;
        shares = data.count;
        return callback(shares);
      }).fail(function() {
        return callback(0);
      });
    };

    Pinterest.prototype.decorate = function(window) {
      window.url = "http://pinterest.com/pin/create/button/?url=" + this.url + "&media=" + this.image + "&description=" + window.title;
      window.width = 770;
      return window.height = 760;
    };

    return Pinterest;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Reddit = (function(superClass) {
    extend(Reddit, superClass);

    function Reddit() {
      return Reddit.__super__.constructor.apply(this, arguments);
    }

    Reddit.label = "Share on Reddit";

    Reddit.prototype.decorate = function(window) {
      window.url = "http://reddit.com/submit?url=" + this.url + "&title=" + window.title;
      window.width = 600;
      return window.height = 500;
    };

    return Reddit;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Tumblr = (function(superClass) {
    extend(Tumblr, superClass);

    function Tumblr() {
      return Tumblr.__super__.constructor.apply(this, arguments);
    }

    Tumblr.label = "Share on Tumblr";

    Tumblr.prototype.decorate = function(window) {
      window.url = "http://www.tumblr.com/share?v=3&u=" + this.url + "&t=" + window.title + "&s=" + window.description;
      window.width = 600;
      return window.height = 500;
    };

    return Tumblr;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Twitter = (function(superClass) {
    extend(Twitter, superClass);

    function Twitter() {
      return Twitter.__super__.constructor.apply(this, arguments);
    }

    Twitter.label = "Tweet It";

    Twitter.prototype.count = function(callback) {
      return $.getJSON("http://urls.api.twitter.com/1/urls/count.json?&url=" + this.url + "&callback=?", function(data) {
        var shares;
        shares = data.count;
        return callback(shares);
      }).fail(function() {
        return callback(0);
      });
    };

    Twitter.prototype.decorate = function(window) {
      var title, via;
      title = encodeURIComponent(window.title);
      window.url = "https://twitter.com/intent/tweet?text=" + title + "&url=" + this.url;
      if (this.data.tags.length) {
        window.url = window.url + "&hashtags=" + (this.data.tags.join(','));
      }
      via = '';
      if (this.data.twitterBy) {
        via = this.data.twitterBy;
      }
      if (this.data.twitterVia) {
        via = this.data.twitterVia;
      }
      if (via) {
        window.url = window.url + "&via=" + via;
      }
      window.width = 480;
      return window.height = 280;
    };

    return Twitter;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Vk = (function(superClass) {
    extend(Vk, superClass);

    function Vk() {
      return Vk.__super__.constructor.apply(this, arguments);
    }

    Vk.label = "Share on VK";

    Vk.prototype.count = function(callback) {
      $.getScript("http://vk.com/share.php?act=count&index=&url=" + this.url).fail(function() {
        return callback(0);
      });
      if (!window.VK) {
        window.VK = {};
      }
      return window.VK.Share = {
        count: (function(_this) {
          return function(id, shares) {
            return callback(shares);
          };
        })(this)
      };
    };

    Vk.prototype.decorate = function(window) {
      window.url = "http://vk.com/share.php?url=" + this.url + "&title=" + window.title + "&image=" + this.image + "&description=" + window.description;
      window.width = 655;
      return window.height = 429;
    };

    return Vk;

  })(this.Maslosoft.AweShare.Adapter);

  jQuery(document).ready(function() {
    return Maslosoft.AweShare.init();
  });

}).call(this);

//# sourceMappingURL=awe-share.js.map
