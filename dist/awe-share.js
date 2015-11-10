(function() {
  var extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    hasProp = {}.hasOwnProperty;

  if (!this.Maslosoft) {
    this.Maslosoft = {};
  }

  this.Maslosoft.AweShare = (function() {
    AweShare.prototype.element = '';

    function AweShare(element) {
      var adapter, adapterName, adapters, data, index, name, ref, ref1;
      this.element = jQuery(element);
      data = this.element.data();
      if (data.services) {
        data.services = data.services.replace(/\s*/g, '').split(',');
      } else {
        data.services = [];
      }
      if (!data.services.length) {
        ref = Maslosoft.AweShare.Adapters;
        for (name in ref) {
          adapter = ref[name];
          data.services.push(this.decamelize(name));
        }
      }
      adapters = {};
      ref1 = data.services;
      for (index in ref1) {
        name = ref1[index];
        adapterName = this.camelize(name);
        if (typeof Maslosoft.AweShare.Adapters[adapterName] === 'function') {
          adapters[name] = Maslosoft.AweShare.Adapters[adapterName];
        } else {
          console.warn("No adapter for " + name + " in", element, (new Error).stack);
          data.services.splice(index, 1);
        }
      }
      new Maslosoft.AweShare.Renderer(this, data, adapters);
      console.log(data.services);
    }

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

    Adapter.prototype.url = '';

    Adapter.prototype.setUrl = function(url1) {
      this.url = url1;
    };

    return Adapter;

  })();

  this.Maslosoft.AweShare.Renderer = (function() {
    function Renderer(sharer, data1, adapters1) {
      var adapter, name, ref;
      this.sharer = sharer;
      this.data = data1;
      this.adapters = adapters1;
      ref = this.adapters;
      for (name in ref) {
        adapter = ref[name];
        this.render(name, adapter);
      }
    }

    Renderer.prototype.render = function(name, adapter) {
      return this.sharer.element.append("<a href=\"\" class=\"awe-share-brand-" + name + "\">\n	<i class='fa fa-2x fa-" + name + "'></i>\n</a>");
    };

    return Renderer;

  })();

  this.Maslosoft.AweShare.Adapters.Delicious = (function(superClass) {
    extend(Delicious, superClass);

    function Delicious() {
      return Delicious.__super__.constructor.apply(this, arguments);
    }

    Delicious.label = "Save to Delicious";

    return Delicious;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Digg = (function(superClass) {
    extend(Digg, superClass);

    function Digg() {
      return Digg.__super__.constructor.apply(this, arguments);
    }

    Digg.label = "Submit to Digg";

    return Digg;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Facebook = (function(superClass) {
    extend(Facebook, superClass);

    function Facebook() {
      return Facebook.__super__.constructor.apply(this, arguments);
    }

    Facebook.label = "Share on Facebook";

    Facebook.prototype.count = function() {
      var shares;
      shares = void 0;
      $.getJSON('http://graph.facebook.com/?callback=?&ids=' + url, function(data) {
        shares = data[url].shares || 0;
        if (shares > 0 || z === 1) {
          el.find('a[data-count="fb"]').after('<span class="share42-counter">' + shares + '</span>');
        }
      });
    };

    return Facebook;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.GooglePlus = (function(superClass) {
    extend(GooglePlus, superClass);

    function GooglePlus() {
      return GooglePlus.__super__.constructor.apply(this, arguments);
    }

    GooglePlus.label = "Share on Google+";

    GooglePlus.prototype.count = function() {
      if (!window.services) {
        window.services = {};
        window.services.gplus = {};
      }
      window.services.gplus.cb = function(number) {
        window.gplusShares = number;
      };
      $.getScript('http://share.yandex.ru/gpp.xml?url=' + this.url, function() {
        var shares;
        shares = window.gplusShares;
        if (shares > 0 || z === 1) {
          el.find('a[data-count="gplus"]').after('<span class="share42-counter">' + shares + '</span>');
        }
      });
    };

    GooglePlus.prototype.decorate = function(window) {};

    return GooglePlus;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Linkedin = (function(superClass) {
    extend(Linkedin, superClass);

    function Linkedin() {
      return Linkedin.__super__.constructor.apply(this, arguments);
    }

    Linkedin.label = "Share on Linkedin";

    return Linkedin;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Pinterest = (function(superClass) {
    extend(Pinterest, superClass);

    function Pinterest() {
      return Pinterest.__super__.constructor.apply(this, arguments);
    }

    Pinterest.label = "Pin It";

    return Pinterest;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Reddit = (function(superClass) {
    extend(Reddit, superClass);

    function Reddit() {
      return Reddit.__super__.constructor.apply(this, arguments);
    }

    Reddit.label = "Share on Reddit";

    return Reddit;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Tumblr = (function(superClass) {
    extend(Tumblr, superClass);

    function Tumblr() {
      return Tumblr.__super__.constructor.apply(this, arguments);
    }

    Tumblr.label = "Share on Tumblr";

    return Tumblr;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Twitter = (function(superClass) {
    extend(Twitter, superClass);

    function Twitter() {
      return Twitter.__super__.constructor.apply(this, arguments);
    }

    Twitter.label = "Tweet It";

    return Twitter;

  })(this.Maslosoft.AweShare.Adapter);

  this.Maslosoft.AweShare.Adapters.Vk = (function(superClass) {
    extend(Vk, superClass);

    function Vk() {
      return Vk.__super__.constructor.apply(this, arguments);
    }

    Vk.label = "Share on VK";

    return Vk;

  })(this.Maslosoft.AweShare.Adapter);

  jQuery(document).ready(function() {
    return Maslosoft.AweShare.init();
  });

}).call(this);

//# sourceMappingURL=awe-share.js.map
