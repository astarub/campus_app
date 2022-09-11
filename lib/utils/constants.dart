//! Uniform Resource Identifiers

// TODO: Write an API for Wordpress events and maybe RUB website too

const String astaEvents = 'https://asta-bochum.de/wp-json/tribe/events/v1/events/';
const String astaFavicon = 'https://asta-bochum.de/wp-content/themes/rt_notio/custom/images/favicon.ico';
const String rubNewsfeed = 'https://news.rub.de/newsfeed'; // there is no non-german

//!

/// Test HTML Response data for news by RUB news for rubnewsTestNewsurl1
const String rubnewsTestsNews1DataSuccess = '''
<!DOCTYPE html>
<html lang="de">
  <head>
    <meta name="viewport" content="width = device-width, initial-scale = 1.0, maximum-scale = 10.0, user-scalable = yes" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta data-embetty-server="https://d8-dev-0001.rub.de/embettygo" />
    <meta name="facebook-domain-verification" content="bb2qa5v0rdhzy5jg4k7p72hujrhc6m" />
    
    <meta charset="utf-8" />
<link rel="canonical" href="/wissenschaft/2022-09-09-biopsychologie-schlaue-voegel-denken-smart-und-sparsam" />
<link rel="shortlink" href="/node/9242" />
<meta property="og:title" content="Schlaue Vögel denken smart und sparsam" />
<meta property="og:description" content="Gegenüber der Energieeffizienz von Vogelgehirnen können wir Säugetiere einpacken.
" />
<meta property="og:image" content="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2021_08_16_km_biopsychologie_tauben-34-auswahl.jpg?itok=PBFSkZyP" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:site" content="@ruhrunibochum" />
<meta name="twitter:title" content="Schlaue Vögel denken smart und sparsam" />
<meta name="twitter:description" content="Gegenüber der Energieeffizienz von Vogelgehirnen können wir Säugetiere einpacken.
" />
<meta name="twitter:image" content="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2021_08_16_km_biopsychologie_tauben-34-auswahl.jpg?itok=PBFSkZyP" />
    <title>Schlaue Vögel denken smart und sparsam - Newsportal - Ruhr-Universität Bochum</title>
    <link rel="shortcut icon" href="https://news.rub.de/sites/all/themes/rub_news/favicon.ico" type="image/vnd.microsoft.icon" />
    <link rel="shortcut icon" href="https://news.rub.de/sites/all/themes/rub_news/favicon.ico" type="image/x-icon" />
    
  <link rel="apple-touch-icon" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon.png" />
  <link rel="apple-touch-icon" sizes="57x57" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-57x57.png" />
  <link rel="apple-touch-icon" sizes="72x72" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-72x72.png" />
  <link rel="apple-touch-icon" sizes="76x76" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-76x76.png" />
  <link rel="apple-touch-icon" sizes="114x114" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-114x114.png" />
  <link rel="apple-touch-icon" sizes="120x120" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-120x120.png" />
  <link rel="apple-touch-icon" sizes="144x144" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-144x144.png" />
  <link rel="apple-touch-icon" sizes="152x152" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-152x152.png" />
  <link rel="apple-touch-icon" sizes="180x180" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-180x180.png" />

    <link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_lQaZfjVpwP_oGNqdtWCSpJT1EMqXdMiU84ekLLxQnc4.css" media="all" />
<link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_TdjZ3GSAWuGH5LPiQf1Ix7-UfWMyrYbCrxZPIwXtcKQ.css" media="all" />
<link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_QG2q-1n8UCGT8cLjx6MlWnjIwX3s7iBNAeMS1XCONMg.css" media="all" />
<link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_vCmpLglhWKumQcHQxvnTyiqcszovkB8okTArH1_L7OQ.css" media="all" />
<link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_XDi3lzI4bFDU0VUyQkZ614zP325idrS4-B6RGdNAeek.css" media="all" />
    <script src="//code.jquery.com/jquery-1.12.4.min.js"></script>
<script>window.jQuery || document.write("<script src='/sites/all/modules/jquery_update/replace/jquery/1.12/jquery.min.js'>\x3C/script>")</script>
<script src="https://news.rub.de/misc/jquery-extend-3.4.0.js?v=1.12.4"></script>
<script src="https://news.rub.de/misc/jquery-html-prefilter-3.5.0-backport.js?v=1.12.4"></script>
<script src="https://news.rub.de/misc/jquery.once.js?v=1.2"></script>
<script src="https://news.rub.de/misc/drupal.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/modules/jquery_update/js/jquery_browser.js?v=0.0.1"></script>
<script src="https://news.rub.de/sites/all/modules/jquery_update/replace/ui/external/jquery.cookie.js?v=67fb34f6a866c40d0570"></script>
<script src="https://news.rub.de/sites/default/files/languages/de_iN0NI4SBNPGoSIrkElRNPZu7WCWlUbS-aX4WFosrstQ.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/modules/matomo/matomo.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/modules/radioactivity/js/radioactivity.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/modules/field_group/field_group.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/libraries/flexslider/jquery.flexslider-min.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/themes/rub_news/js/flexslider-ini.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/themes/rub_news/js/embetty.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/themes/rub_news/js/js-cookie.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/themes/rub_news/js/main.js?rganwc"></script>
<script>jQuery.extend(Drupal.settings, {"basePath":"\/","pathPrefix":"","setHasJsCookie":0,"ajaxPageState":{"theme":"rub_news","theme_token":"YDWtJ8QNZboMQ9lcs0uFbwsQMSicQ6FlXprYt69V4lY","js":{"0":1,"sites\/all\/libraries\/shariff\/build\/shariff.min.js":1,"\/\/code.jquery.com\/jquery-1.12.4.min.js":1,"1":1,"misc\/jquery-extend-3.4.0.js":1,"misc\/jquery-html-prefilter-3.5.0-backport.js":1,"misc\/jquery.once.js":1,"misc\/drupal.js":1,"sites\/all\/modules\/jquery_update\/js\/jquery_browser.js":1,"sites\/all\/modules\/jquery_update\/replace\/ui\/external\/jquery.cookie.js":1,"public:\/\/languages\/de_iN0NI4SBNPGoSIrkElRNPZu7WCWlUbS-aX4WFosrstQ.js":1,"sites\/all\/modules\/matomo\/matomo.js":1,"sites\/all\/modules\/radioactivity\/js\/radioactivity.js":1,"sites\/all\/modules\/field_group\/field_group.js":1,"sites\/all\/libraries\/flexslider\/jquery.flexslider-min.js":1,"sites\/all\/themes\/rub_news\/js\/flexslider-ini.js":1,"sites\/all\/themes\/rub_news\/js\/embetty.js":1,"sites\/all\/themes\/rub_news\/js\/js-cookie.js":1,"sites\/all\/themes\/rub_news\/js\/main.js":1},"css":{"modules\/system\/system.base.css":1,"modules\/system\/system.menus.css":1,"modules\/system\/system.messages.css":1,"modules\/system\/system.theme.css":1,"modules\/field\/theme\/field.css":1,"modules\/node\/node.css":1,"modules\/search\/search.css":1,"modules\/user\/user.css":1,"sites\/all\/modules\/webform_confirm_email\/webform_confirm_email.css":1,"sites\/all\/modules\/workflow\/workflow_admin_ui\/workflow_admin_ui.css":1,"sites\/all\/modules\/views\/css\/views.css":1,"sites\/all\/modules\/ckeditor\/css\/ckeditor.css":1,"sites\/all\/modules\/ctools\/css\/ctools.css":1,"sites\/all\/libraries\/shariff\/build\/shariff.complete.css":1,"sites\/all\/modules\/radioactivity\/css\/radioactivity.css":1,"sites\/all\/modules\/ds\/layouts\/ds_2col\/ds_2col.css":1,"sites\/all\/themes\/rub_news\/system.menus.css":1,"sites\/all\/themes\/rub_news\/system.messages.css":1,"sites\/all\/themes\/rub_news\/system.theme.css":1,"sites\/all\/themes\/rub_news\/css\/05-admin.css":1,"sites\/all\/themes\/rub_news\/css\/10-structure.css":1,"sites\/all\/themes\/rub_news\/css\/12-buttons-label-pager.css":1,"sites\/all\/themes\/rub_news\/css\/14-filter.css":1,"sites\/all\/themes\/rub_news\/css\/16-webforms.css.less":1,"sites\/all\/themes\/rub_news\/css\/18-forms.css":1,"sites\/all\/themes\/rub_news\/css\/20-main-menu.css":1,"sites\/all\/themes\/rub_news\/css\/24-sub-menu.css":1,"sites\/all\/themes\/rub_news\/css\/26-meta-menu.css":1,"sites\/all\/themes\/rub_news\/css\/28-footer.css":1,"sites\/all\/themes\/rub_news\/css\/30-teaser-a.css":1,"sites\/all\/themes\/rub_news\/css\/32-teaser-a-slider.css":1,"sites\/all\/themes\/rub_news\/css\/34-teaser-b.css":1,"sites\/all\/themes\/rub_news\/css\/36-teaser-c.css":1,"sites\/all\/themes\/rub_news\/css\/38-teaser-d.css":1,"sites\/all\/themes\/rub_news\/css\/40-teaser-e.css":1,"sites\/all\/themes\/rub_news\/css\/42-teaser-box-triple.css":1,"sites\/all\/themes\/rub_news\/css\/44-teaser-box-double.css":1,"sites\/all\/themes\/rub_news\/css\/60-node-article.css":1,"sites\/all\/themes\/rub_news\/css\/62-node-article-left.css":1,"sites\/all\/themes\/rub_news\/css\/64-node-article-right.css":1,"sites\/all\/themes\/rub_news\/css\/66-node-article-flex.css":1,"sites\/all\/themes\/rub_news\/css\/68-node-article-flex-downloads.css":1,"sites\/all\/themes\/rub_news\/css\/70-node-serie-dossier-galerie-medien.css":1,"sites\/all\/themes\/rub_news\/css\/72-mensa.css":1,"sites\/all\/themes\/rub_news\/css\/74-redaktion-mitglieder.css":1,"sites\/all\/themes\/rub_news\/css\/76-user-profile.css":1,"sites\/all\/themes\/rub_news\/css\/80-node-standard.css":1,"sites\/all\/themes\/rub_news\/css\/82-node-standard-standard-left.css":1,"sites\/all\/themes\/rub_news\/css\/86-misc.css":1,"sites\/all\/themes\/rub_news\/css\/88-misc-ex-strat.css":1,"sites\/all\/themes\/rub_news\/css\/92-graceful-degradation.css":1,"sites\/all\/themes\/rub_news\/css\/99-dev.css":1,"sites\/all\/themes\/rub_news\/css\/100-web-cd.css":1,"sites\/all\/themes\/rub_news\/css\/user.css":1,"public:\/\/fontyourface\/local_fonts\/RUB_Nepo_Icons-normal-normal\/stylesheet.css":1}},"matomo":{"trackMailto":1},"radioactivity":{"emitters":{"emitDefault":{"c8de926475ff804d2fb648511713b646":{"accuracy":"100","bundle":"standard","energy":10,"entity_id":"9242","entity_type":"node","field_name":"field_radioactivity","language":"und","storage":"File","type":"none","checksum":"c8de926475ff804d2fb648511713b646"}}},"config":{"emitPath":"\/sites\/all\/modules\/radioactivity\/emit.php","fpEnabled":1,"fpTimeout":"5"}},"field_group":{"div":"full"}});</script>
    
  </head>
  
  <body class="html not-front not-logged-in no-sidebars page-node page-node- page-node-9242 node-type-standard i18n-de section-wissenschaft role-anonymous-user no-js "  >
    
    <div class="https://news.rub.de" id="base-url" style="display: none; visibility: hidden;"></div>

          <p id="skip-link">
        <a href="#main-menu" class="element-invisible element-focusable">Jump to navigation</a>
      </p>
    
        
<div id="header-wrapper">
  <div id="header-inner-wrapper">
    <div id="header-left">
      <div id="header-left-inner">
        <a href="http://www.ruhr-uni-bochum.de"><img class="rub-logo" src="https://news.rub.de/sites/all/themes/rub_news/logo.png" alt="Logo RUB"></a>
      </div>
    </div>
    
    <div id="header-center">
        <div class="region region-main-menu">
    <div id="block-system-main-menu" class="block block-system block-menu first last odd" role="navigation">

      
  <ul class="menu"><li class="menu__item is-leaf first leaf"><a href="https://www.ruhr-uni-bochum.de/de/informationen-zu-corona" target="_blank" class="menu__link">Corona-Infos</a></li>
<li class="menu__item is-leaf leaf"><a href="https://studium.ruhr-uni-bochum.de/de" class="menu__link">Studium</a></li>
<li class="menu__item is-leaf leaf"><a href="https://forschung.ruhr-uni-bochum.de/de" class="menu__link">Forschung</a></li>
<li class="menu__item is-leaf leaf"><a href="https://transfer.ruhr-uni-bochum.de/de" class="menu__link">Transfer</a></li>
<li class="menu__item is-leaf leaf"><a href="/" class="menu__link">News</a></li>
<li class="menu__item is-leaf leaf"><a href="https://uni.ruhr-uni-bochum.de/de" class="menu__link">Über uns</a></li>
<li class="menu__item is-leaf last leaf"><a href="https://einrichtungen.ruhr-uni-bochum.de/de" class="menu__link">Einrichtungen</a></li>
</ul>
</div>
  </div>
      <a id="nav-burger" href="#"></a> 
    </div>
    
    <div id="header-right">
      &nbsp;
    </div>
    
    <div class="clear"></div>
  </div>
</div>

<div id="nav-bg"></div>
<div id="subnav-bg"></div>

<div id="meta-menu-wrapper">
  <div id="sub-menu-and-content-wrapper" >
  
    <noscript>
      <div id="no-script-wrapper">
        <div id="no-script-inner"> 
          <span>Um diese Webseite vollumfänglich nutzen zu können, benötigen Sie JavaScript.</span><br /> 
          <a href="http://www.enable-javascript.com/de/" target="_blank">Hier finden Sie eine Anleitung, wie Sie JavaScript in Ihrem Browser einschalten.</a>
        </div>
      </div>
    </noscript>
  
    <div id="sub-menu">
      <div id="sub-menu-inner">
        
        <div id="menu-button">MENÜ</div>
        
                
        <ul class="menu rub-startseite">
          <li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
          <li class="menu__item is-leaf leaf" id="rub-star-item"><a href="http://www.rub.de" class="menu__link">RUB-STARTSEITE</a></li>
          <li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
        </ul>
        
          <div class="region region-sub-menu">
    <div id="block-menu-menu-sek-rmenu-newsportal" class="block block-menu first last odd" role="navigation">

      
  <ul class="menu"><li class="menu__item is-leaf first leaf" id="root-item"><a href="/" class="menu__link">News</a></li>
<li class="menu__item is-leaf is-active-trail leaf active-trail"><a href="/wissenschaft" class="menu__link is-active-trail is-active active-trail active">Wissenschaft</a></li>
<li class="menu__item is-leaf leaf"><a href="/studium" class="menu__link">Studium</a></li>
<li class="menu__item is-leaf leaf"><a href="/transfer" class="menu__link">Transfer</a></li>
<li class="menu__item is-leaf leaf"><a href="/leute" class="menu__link">Leute</a></li>
<li class="menu__item is-leaf leaf"><a href="/hochschulpolitik" class="menu__link">Hochschulpolitik</a></li>
<li class="menu__item is-leaf leaf"><a href="/kultur-und-freizeit" class="menu__link">Kultur und Freizeit</a></li>
<li class="menu__item is-leaf leaf"><a href="/vermischtes" class="menu__link">Vermischtes</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-collapsed collapsed"><a href="/servicemeldungen" class="menu__link">Servicemeldungen</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-leaf leaf"><a href="/serien" class="menu__link">Serien</a></li>
<li class="menu__item is-leaf leaf"><a href="/dossiers" class="menu__link">Dossiers</a></li>
<li class="menu__item is-leaf leaf"><a href="/bildergalerien" class="menu__link">Bildergalerien</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-expanded expanded" id="menu-item-pi"><a href="/presseinformationen" class="menu__link">Presseinformationen</a><ul class="menu"><li class="menu__item is-leaf first last leaf level-2"><a href="/presseinformationen/abo" class="menu__link">Abonnieren</a></li>
</ul></li>
<li class="menu__item is-expanded expanded"><a href="/rub-in-den-medien" class="menu__link">RUB in den Medien</a><ul class="menu"><li class="menu__item is-leaf first last leaf level-2"><a href="/rub-in-den-medien/abo" class="menu__link">Abonnieren</a></li>
</ul></li>
<li class="menu__item is-collapsed collapsed"><a href="/rubens" class="menu__link">Rubens</a></li>
<li class="menu__item is-expanded expanded"><a href="/rubin" class="menu__link">Rubin</a><ul class="menu"><li class="menu__item is-leaf first leaf level-2"><a href="/rubin/abo" class="menu__link">Abonnieren</a></li>
<li class="menu__item is-leaf last leaf level-2"><a href="/rubin/printarchiv" class="menu__link">Printarchiv</a></li>
</ul></li>
<li class="menu__item is-collapsed collapsed"><a href="/archiv" class="menu__link">Archiv</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-collapsed collapsed"><a href="/english" class="menu__link">English</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-leaf leaf"><a href="/redaktion" class="menu__link">Redaktion</a></li>
<li class="menu__item is-leaf last leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
</ul>
</div>
  </div>
        
        <a id="subnav-arrow" href="#"></a>
      </div>
    </div>
     
    <div id="content">
    
      <div id="content-inner">
        
              
        <div id="messages-wrapper">  
                  </div>

        <h1>Newsportal - Ruhr-Universität Bochum</h1>
        
                
                
        <a id="main-content"></a>
                        
        



<div  class="ds-2col node node-standard view-mode-full clearfix language-de">

  
  <div class="group-left">
    <div class="group-left-inner ">
      
  <div class="field-std-bild-artikel">
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2021_08_16_km_biopsychologie_tauben-34-auswahl.jpg?itok=PBFSkZyP" width="804" height="536" alt="Taube" />  </div>

  <div class="field-bildzeile-custom-">
    
      <div class="bildzeile-wrapper">
        <div class="bildzeile-text">
          <span class="bildzeile-text-inner">
	Vögel benötigen für ihr Gehirn wesentlich weniger Energie als Säugetiere.</span>
        </div>
        <span class="bildzeile-copyright">&copy;&nbsp;RUB, Marquard
</span>
      </div>
      </div>
<div class="content-inner-inner-wrapper">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Biopsychologie</div>
      </div>
</div>

  <h2 class="field-std-headline">
    Schlaue Vögel denken smart und sparsam  </h2>

  <div class="field-std-teaser">
    <p>Gegenüber der Energieeffizienz von Vogelgehirnen können wir Säugetiere einpacken.</p>
  </div>

  <div class="field-std-text">
    <p>Die Gehirnzellen von Vögeln benötigen nur etwa ein Drittel der Energie, die Säugetiere aufwenden müssen, um ihr Gehirn zu versorgen. „Das erklärt zum Teil, wie Vögel es schaffen, so schlau zu sein, obwohl ihre Gehirne so viel kleiner sind als die von Säugetieren“, sagt Prof. Dr. Onur Güntürkün, Leiter der Arbeitseinheit Biopsychologie der RUB. Sein Forschungsteam untersuchte gemeinsam mit Kolleginnen und Kollegen aus Köln, Jülich und Düsseldorf den Energieverbrauch der Gehirne von Tauben mit bildgebenden Methoden. Die Forschenden berichten in der Zeitschrift Current Biology vom 8. September 2022.</p>
<h4>
	Warum es eine Krähe mit einem Schimpansen aufnehmen kann</h4>
<p>Unser Gehirn macht nur etwa zwei Prozent unseres Körpergewichts aus, verbraucht aber etwa 20 bis 25 Prozent der Körperenergie. „Das Gehirn ist damit das mit Abstand energetisch teuerste Organ unseres Körpers, und wir konnten es uns im Laufe der Evolution nur leisten, indem wir uns erfolgreich sehr viel Energie zuzuführen lernten“, erklärt Güntürkün. Die Gehirne von Vögeln sind im Vergleich viel kleiner. Trotzdem sind Vögel genauso schlau wie so manche Säuger: Krähen und Papageien zum Beispiel, deren Gehirne nur etwa 10 bis 20 Gramm wiegen, können es kognitiv durchaus mit einem Schimpansen aufnehmen, dessen Gehirn 400 Gramm auf die Waage bringt.</p>
<p>Güntürkün und sein Team die Gehirne von Tauben genauer unter die Lupe. Dafür nutzten sie die Methode der Positronen-Emissions-Tomografie, kurz PET. Dank eines speziellen Kontrastmittels konnten sie anhand der damit erzielten Bilder abschätzen, wie viel Glukose die Nervenzellen im Gehirn der Tauben im wachen und im narkotisierten Zustand jeweils verbrauchten. Der Energieverbrauch betrug demnach nur ein Drittel dessen, was ein Säugetiergehirn verbraucht.</p>
<p>"Dass der Unterschied so groß ist, bedeutet, dass Vögel zusätzliche Mechanismen besitzen, die den Energieverbrauch der Nervenzellen senken. Das könnte zum Teil mit der höheren Körpertemperatur von Vögeln zusammenhängen, aber wahrscheinlich auch mit zusätzlichen Faktoren, die derzeit noch völlig unbekannt sind“, erklärt der Forscher. „Unsere Studie fügt sich in eine wachsende Zahl von Studien ein, die zeigen, dass Vögel in der Evolution einen eigenen und sehr erfolgreichen Weg zur Entstehung intelligenter Gehirne entwickelt haben.“</p>

            <div class="flex infobox-wrapper ">
              <div class="infobox-header">
                Angeklickt
              </div>
              <div class="infobox-text">
                
                <ul>
	<li>
		<a href="/presseinformationen/wissenschaft/2022-09-01-biopsychologie-schlaue-voegel-denken-smart-und-sparsam">Ausführliche Presseinformation</a></li>
</ul>

              </div>
            </div>
          
  </div>
</div>    </div>
  </div>

  <div class="group-right">
    <div class="group-right-inner">
      
  <div class="field-test">
    
      <div class="published-wrapper">
        <div class="published-label">Veröffentlicht</div>
        Freitag<br />9. September 2022<br />09.11 Uhr
      </div>
    

  </div>

  <div class="field-urheber-custom-">
    
    <div class="urheber-wrapper">
      <div class="urheber-label">Von</div>
      <a href="/redaktion/meike-driessen-md">Meike Drießen (md)</a>
      
    </div>
    </div>
<div class="shariff-wrapper"><div class="label-above lang-en">Share</div><div class="label-above lang-de">Teilen</div><div class="shariff"  data-mail-body="Hallo,
  
diesen Artikel habe ich im Newsportal der Ruhr-Universität Bochum gefunden:

https://news.rub.de/wissenschaft/2022-09-09-biopsychologie-schlaue-voegel-denken-smart-und-sparsam

Viele Grüße!

- - -

Alle News rund um die Ruhr-Universität Bochum: http://news.rub.de"  data-title="Biopsychologie: Schlaue Vögel denken smart und sparsam -" data-services="[&quot;twitter&quot;,&quot;facebook&quot;,&quot;whatsapp&quot;,&quot;mail&quot;]" data-theme="grey" data-orientation="vertical" data-twitter-via="ruhrunibochum" data-mail-url="mailto:" data-mail-subject="Artikelempfehlung: Schlaue Vögel denken smart und sparsam – news.rub.de" data-lang="de" data-url="https://news.rub.de/wissenschaft/2022-09-09-biopsychologie-schlaue-voegel-denken-smart-und-sparsam"></div></div>    </div>
  </div>

</div>

   
  
      <div class="teaser-box triple">
        <div class="teaser-box-header">Das könnte Sie auch interessieren</div>
          <div class="item item-1"><a href="/wissenschaft/2021-12-17-kognitive-neurowissenschaften-begrenzter-speicherplatz-bei-menschen-und-voegeln" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2012_12_xx_kraehe_lukas_hahn_sfb_874_susanne_troll.jpg?itok=dLYgNWcL" width="804" height="536" alt="Eine Krähe sitzt auf einem Arm von einem Menschen" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Kognitive Neurowissenschaften</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Begrenzter Speicherplatz bei Menschen und Vögeln  
</h2>
          </div>
        </div>
      </a></div><div class="item item-2"><a href="/wissenschaft/2022-07-22-biologie-ein-aus-schalter-fuer-die-aggression" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2022_07_06_bohne-rybarski_mark-2-km.jpg?itok=jqaljCda" width="804" height="536" alt="Pauline Bohne und Melanie Mark" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Biologie</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Ein Aus-Schalter für die Aggression  
</h2>
          </div>
        </div>
      </a></div><div class="item item-3"><a href="/wissenschaft/2022-07-13-biologie-wie-sich-wasserfloehe-gegen-fleischfressende-pflanzen-verteidigen" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2022_07_05_km_wasserfloehe-6.jpg?itok=Hj_DEu3M" width="804" height="536" alt="Person mit Weckglas, das Pflanzen enthält" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Biologie</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Wie sich Wasserflöhe gegen fleischfressende Pflanzen verteidigen  
</h2>
          </div>
        </div>
      </a></div>
        <div class="clear"></div>
      </div>
      
  
      <div class="teaser-box triple">
        <div class="teaser-box-header">Derzeit beliebt</div>
          <div class="item item-1"><a href="/wissenschaft/2022-09-07-psychologie-sportrunde-drehen-statt-social-media-story-sehen" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2020_02_19_km_laufen-9.jpg?itok=1sB480zj" width="804" height="536" alt="Läuferin" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Psychologie</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Sportrunde drehen statt Social-Media-Story sehen  
</h2>
          </div>
        </div>
      </a></div><div class="item item-2"><a href="/wissenschaft/2019-12-10-religion-existiert-gott" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/goecke_benedikt_km-3.jpg?itok=f278wErc" width="804" height="536" alt="Benedikt Göcke, Blue Square, Veranstaltung" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Religion</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Existiert Gott?  
</h2>
          </div>
        </div>
      </a></div><div class="item item-3"><a href="/hochschulpolitik/2022-09-09-erstes-alumni-treffen-erfolgreich-ueber-die-studienbruecke-gegangen" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2022_09_08_km_studienbruecke_-9.jpg?itok=w3PSJAZ3" width="804" height="536" alt="Santiago Soares aus Brasilien, Sofia Kostiukovska aus der Ukraine und Miles Lunger aus den USA (von links) sind drei junge Menschen, die stellvertretend für die vielen Studienbrücklerinnen und -brückler aus alller Welt stehen." />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Erstes Alumni-Treffen</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Erfolgreich über die Studienbrücke gegangen  
</h2>
          </div>
        </div>
      </a></div>
        <div class="clear"></div>
      </div>
      
   
    
    <div class="button-further-article-wrapper ressort wissenschaft">
      <div class="button-further ressort">
        <a href="/wissenschaft" class="hover-layer">
    
    <div class="img-wrapper">
      <div class="img-wrapper-inner">
        &nbsp;
      </div>
    </div>
  
    <div class="article-info-wrapper">
      <div class="article-info-wrapper-inner">
        <div class="headline">Mehr Wissenschaft</div>
        <div class="button-arrow-wrapper no-link">
          <span class="button-arrow-arrow"><!-- --></span>
          <span class="button-arrow-text">Ressort</span>
        </div>
      </div>
    </div>
    <div class="clear"></div>
  </a>
      </div>
    </div>
    

 
  <div class="last-child">
           
    <div class="button-further-article-wrapper">
      <div class="button-further start">
        <a href="https://news.rub.de" class="hover-layer">
    
    <div class="img-wrapper">
      <div class="img-wrapper-inner">
        &nbsp;
      </div>
    </div>
  
    <div class="article-info-wrapper">
      <div class="article-info-wrapper-inner">
        <div class="headline">Zur Startseite</div>
        <div class="button-arrow-wrapper no-link">
          <span class="button-arrow-arrow"><!-- --></span>
          <span class="button-arrow-text">News</span>
        </div>
      </div>
    </div>
    <div class="clear"></div>
  </a>
      </div>
    </div>
        </div>




<div id="block-menu-menu-metamenu-nepo" class="block block-menu last even" role="navigation">

      
  <ul class="menu"><li class="menu__item is-leaf first leaf blue"><a href="http://www.ruhr-uni-bochum.de/a-z/" title="Zum A-Z" target="_blank" class="menu__link">A-Z</a></li>
<li class="menu__item is-leaf leaf blue" id="button-contrast-meta"><a href="/" title="Kontrast" class="menu__link">N</a></li>
<li class="menu__item is-leaf leaf green newsfeed"><a href="/newsfeed" title="Newsfeed" target="_blank" class="menu__link">K</a></li>
<li class="menu__item is-leaf leaf green social-fb"><a href="https://www.facebook.com/RuhrUniBochum" title="RUB bei Facebook" target="_blank" class="menu__link"></a></li>
<li class="menu__item is-leaf leaf green social-tw"><a href="http://twitter.com/ruhrunibochum" title="RUB bei Twitter" target="_blank" class="menu__link"></a></li>
<li class="menu__item is-leaf last leaf green social-ig"><a href="http://instagram.com/ruhrunibochum" title="RUB bei Instagram" target="_blank" class="menu__link"></a></li>
</ul>
</div>
      
      </div>
    </div>

    <div class="clear"></div>
  </div>
</div>


<div id="pre-footer-wrapper">
  </div>  


<div id="footer-wrapper">
  <div id="footer-inner-wrapper">
    <div id="footer-left">
      <div id="footer-left-inner">
        <a href="http://www.ruhr-uni-bochum.de"><img class="rub-logo" src="https://news.rub.de/sites/all/themes/rub_news/logo.png" alt="Logo RUB"></a>
        
        <div class="footer-text impressum impressum-logo">
          <a href="http://www.ruhr-uni-bochum.de/impressum.htm">Impressum</a> |
          <a href="http://www.ruhr-uni-bochum.de/kontakt">Kontakt</a>
        </div>
        
      </div>
    </div>
    
    <div id="footer-right">
      <div id="footer-right-inner">
              

        <div class="footer-text left">
          <div><strong>Ruhr-Universität Bochum</strong></div>
          Universitätsstraße 150<br />
          44801 Bochum<br /><br />
          <a target="_blank" href="https://www.ruhr-uni-bochum.de/de/datenschutzhinweise">Datenschutz</a><br />
          <a target="_blank" href="https://www.ruhr-uni-bochum.de/de/barrierefreiheit">Barrierefreiheit</a><br />
          <a target="_blank" href="http://www.ruhr-uni-bochum.de/impressum.htm">Impressum</a>
        </div>
        <div class="footer-text center-left">
          <div><strong>Schnellzugriff</strong></div>
          <a target="_blank" href="http://uni.ruhr-uni-bochum.de/de/service-und-themen">Service und Themen</a><br />
          <a target="_blank" href="http://www.rub.de/anreise">Anreise und Lagepläne</a><br />
          <a target="_blank" href="https://notfall.rub.de/">Hilfe im Notfall</a><br />
          <a target="_blank" href="https://uni.ruhr-uni-bochum.de/de/stellenangebote">Stellenangebote</a><br />
        </div>
        <div class="footer-text center-right">
          <div><strong>Social Media</strong></div>
          <a target="_blank" href="https://www.facebook.com/RuhrUniBochum">Facebook</a><br />
          <a target="_blank" href="https://twitter.com/ruhrunibochum">Twitter</a><br />
          <a target="_blank" href="https://www.youtube.com/user/ruhruniversitaet/">YouTube</a><br />
          <a target="_blank" href="https://instagram.com/ruhrunibochum">Instagram</a><br />
        </div>
        <div class="footer-text right">
          <div class="right-inner">
            <a href="#" id="button-to-top">Seitenanfang <span class="arrow-up">y</span></a>
            <a href="#" id="button-contrast">Kontrast <span class="arrow-up">N</span></a>
          </div>
        </div>
        <div class="clear"></div>
        
        <div class="footer-text impressum impressum-small">
          <a target="_blank" href="http://www.ruhr-uni-bochum.de/impressum.htm">Impressum</a> |
          <a target="_blank" href="http://www.ruhr-uni-bochum.de/kontakt">Kontakt</a>
        </div>
        
      </div>
    </div>
    
    <div class="clear"></div>
  </div>
</div>
    <script>var _paq = _paq || [];(function(){var u=(("https:" == document.location.protocol) ? "https://statistic.ruhr-uni-bochum.de/" : "https://statistic.ruhr-uni-bochum.de/");_paq.push(["setSiteId", "3"]);_paq.push(["setTrackerUrl", u+"matomo.php"]);_paq.push(["setDoNotTrack", 1]);_paq.push(["disableCookies"]);_paq.push(["trackPageView"]);_paq.push(["setIgnoreClasses", ["no-tracking","colorbox"]]);_paq.push(["enableLinkTracking"]);var d=document,g=d.createElement("script"),s=d.getElementsByTagName("script")[0];g.type="text/javascript";g.defer=true;g.async=true;g.src=u+"matomo.js";s.parentNode.insertBefore(g,s);})();</script>
<script src="https://news.rub.de/sites/all/libraries/shariff/build/shariff.min.js?rganwc"></script>
    
        
    
  </body>
</html>
''';

/// Test HTML Response data for news by RUB news for rubnewsTestNewsurl1
const String rubnewsTestsNews2DataSuccess = '''
<!DOCTYPE html>
<html lang="de">
  <head>
    <meta name="viewport" content="width = device-width, initial-scale = 1.0, maximum-scale = 10.0, user-scalable = yes" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta data-embetty-server="https://d8-dev-0001.rub.de/embettygo" />
    <meta name="facebook-domain-verification" content="bb2qa5v0rdhzy5jg4k7p72hujrhc6m" />
    
    <meta charset="utf-8" />
<link rel="canonical" href="/kultur-und-freizeit/2022-08-12-fotografie-neue-bilder-fuer-die-stiftung-situation-kunst" />
<link rel="shortlink" href="/node/9177" />
<meta property="og:title" content="Neue Bilder für die Stiftung Situation Kunst" />
<meta property="og:description" content="Der Fotograf Dietmar Riemann hat ihr sein gesamtes Werk geschenkt. Studierende sichten nun die Fotos.
" />
<meta property="og:image" content="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/07_kita.jpg?itok=zFSUaTtI" />
<meta name="twitter:card" content="summary_large_image" />
<meta name="twitter:site" content="@ruhrunibochum" />
<meta name="twitter:title" content="Neue Bilder für die Stiftung Situation Kunst" />
<meta name="twitter:description" content="Der Fotograf Dietmar Riemann hat ihr sein gesamtes Werk geschenkt. Studierende sichten nun die Fotos.
" />
<meta name="twitter:image" content="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/07_kita.jpg?itok=zFSUaTtI" />
    <title>Neue Bilder für die Stiftung Situation Kunst - Newsportal - Ruhr-Universität Bochum</title>
    <link rel="shortcut icon" href="https://news.rub.de/sites/all/themes/rub_news/favicon.ico" type="image/vnd.microsoft.icon" />
    <link rel="shortcut icon" href="https://news.rub.de/sites/all/themes/rub_news/favicon.ico" type="image/x-icon" />
    
  <link rel="apple-touch-icon" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon.png" />
  <link rel="apple-touch-icon" sizes="57x57" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-57x57.png" />
  <link rel="apple-touch-icon" sizes="72x72" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-72x72.png" />
  <link rel="apple-touch-icon" sizes="76x76" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-76x76.png" />
  <link rel="apple-touch-icon" sizes="114x114" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-114x114.png" />
  <link rel="apple-touch-icon" sizes="120x120" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-120x120.png" />
  <link rel="apple-touch-icon" sizes="144x144" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-144x144.png" />
  <link rel="apple-touch-icon" sizes="152x152" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-152x152.png" />
  <link rel="apple-touch-icon" sizes="180x180" href="https://news.rub.de/sites/all/themes/rub_news/touch-icons/apple-touch-icon-180x180.png" />

    <link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_lQaZfjVpwP_oGNqdtWCSpJT1EMqXdMiU84ekLLxQnc4.css" media="all" />
<link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_TdjZ3GSAWuGH5LPiQf1Ix7-UfWMyrYbCrxZPIwXtcKQ.css" media="all" />
<link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_QG2q-1n8UCGT8cLjx6MlWnjIwX3s7iBNAeMS1XCONMg.css" media="all" />
<link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_vCmpLglhWKumQcHQxvnTyiqcszovkB8okTArH1_L7OQ.css" media="all" />
<link type="text/css" rel="stylesheet" href="https://news.rub.de/sites/default/files/css/css_XDi3lzI4bFDU0VUyQkZ614zP325idrS4-B6RGdNAeek.css" media="all" />
    <script src="//code.jquery.com/jquery-1.12.4.min.js"></script>
<script>window.jQuery || document.write("<script src='/sites/all/modules/jquery_update/replace/jquery/1.12/jquery.min.js'>\x3C/script>")</script>
<script src="https://news.rub.de/misc/jquery-extend-3.4.0.js?v=1.12.4"></script>
<script src="https://news.rub.de/misc/jquery-html-prefilter-3.5.0-backport.js?v=1.12.4"></script>
<script src="https://news.rub.de/misc/jquery.once.js?v=1.2"></script>
<script src="https://news.rub.de/misc/drupal.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/modules/jquery_update/js/jquery_browser.js?v=0.0.1"></script>
<script src="https://news.rub.de/sites/all/modules/jquery_update/replace/ui/external/jquery.cookie.js?v=67fb34f6a866c40d0570"></script>
<script src="https://news.rub.de/sites/default/files/languages/de_iN0NI4SBNPGoSIrkElRNPZu7WCWlUbS-aX4WFosrstQ.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/modules/matomo/matomo.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/modules/radioactivity/js/radioactivity.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/modules/field_group/field_group.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/libraries/flexslider/jquery.flexslider-min.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/themes/rub_news/js/flexslider-ini.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/themes/rub_news/js/embetty.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/themes/rub_news/js/js-cookie.js?rganwc"></script>
<script src="https://news.rub.de/sites/all/themes/rub_news/js/main.js?rganwc"></script>
<script>jQuery.extend(Drupal.settings, {"basePath":"\/","pathPrefix":"","setHasJsCookie":0,"ajaxPageState":{"theme":"rub_news","theme_token":"EofWWG4_BxPyomTrLxAHqQyaaS9ToduPzHHS8Vw2r1c","js":{"0":1,"sites\/all\/libraries\/shariff\/build\/shariff.min.js":1,"\/\/code.jquery.com\/jquery-1.12.4.min.js":1,"1":1,"misc\/jquery-extend-3.4.0.js":1,"misc\/jquery-html-prefilter-3.5.0-backport.js":1,"misc\/jquery.once.js":1,"misc\/drupal.js":1,"sites\/all\/modules\/jquery_update\/js\/jquery_browser.js":1,"sites\/all\/modules\/jquery_update\/replace\/ui\/external\/jquery.cookie.js":1,"public:\/\/languages\/de_iN0NI4SBNPGoSIrkElRNPZu7WCWlUbS-aX4WFosrstQ.js":1,"sites\/all\/modules\/matomo\/matomo.js":1,"sites\/all\/modules\/radioactivity\/js\/radioactivity.js":1,"sites\/all\/modules\/field_group\/field_group.js":1,"sites\/all\/libraries\/flexslider\/jquery.flexslider-min.js":1,"sites\/all\/themes\/rub_news\/js\/flexslider-ini.js":1,"sites\/all\/themes\/rub_news\/js\/embetty.js":1,"sites\/all\/themes\/rub_news\/js\/js-cookie.js":1,"sites\/all\/themes\/rub_news\/js\/main.js":1},"css":{"modules\/system\/system.base.css":1,"modules\/system\/system.menus.css":1,"modules\/system\/system.messages.css":1,"modules\/system\/system.theme.css":1,"modules\/field\/theme\/field.css":1,"modules\/node\/node.css":1,"modules\/search\/search.css":1,"modules\/user\/user.css":1,"sites\/all\/modules\/webform_confirm_email\/webform_confirm_email.css":1,"sites\/all\/modules\/workflow\/workflow_admin_ui\/workflow_admin_ui.css":1,"sites\/all\/modules\/views\/css\/views.css":1,"sites\/all\/modules\/ckeditor\/css\/ckeditor.css":1,"sites\/all\/modules\/ctools\/css\/ctools.css":1,"sites\/all\/libraries\/shariff\/build\/shariff.complete.css":1,"sites\/all\/modules\/radioactivity\/css\/radioactivity.css":1,"sites\/all\/modules\/ds\/layouts\/ds_2col\/ds_2col.css":1,"sites\/all\/themes\/rub_news\/system.menus.css":1,"sites\/all\/themes\/rub_news\/system.messages.css":1,"sites\/all\/themes\/rub_news\/system.theme.css":1,"sites\/all\/themes\/rub_news\/css\/05-admin.css":1,"sites\/all\/themes\/rub_news\/css\/10-structure.css":1,"sites\/all\/themes\/rub_news\/css\/12-buttons-label-pager.css":1,"sites\/all\/themes\/rub_news\/css\/14-filter.css":1,"sites\/all\/themes\/rub_news\/css\/16-webforms.css.less":1,"sites\/all\/themes\/rub_news\/css\/18-forms.css":1,"sites\/all\/themes\/rub_news\/css\/20-main-menu.css":1,"sites\/all\/themes\/rub_news\/css\/24-sub-menu.css":1,"sites\/all\/themes\/rub_news\/css\/26-meta-menu.css":1,"sites\/all\/themes\/rub_news\/css\/28-footer.css":1,"sites\/all\/themes\/rub_news\/css\/30-teaser-a.css":1,"sites\/all\/themes\/rub_news\/css\/32-teaser-a-slider.css":1,"sites\/all\/themes\/rub_news\/css\/34-teaser-b.css":1,"sites\/all\/themes\/rub_news\/css\/36-teaser-c.css":1,"sites\/all\/themes\/rub_news\/css\/38-teaser-d.css":1,"sites\/all\/themes\/rub_news\/css\/40-teaser-e.css":1,"sites\/all\/themes\/rub_news\/css\/42-teaser-box-triple.css":1,"sites\/all\/themes\/rub_news\/css\/44-teaser-box-double.css":1,"sites\/all\/themes\/rub_news\/css\/60-node-article.css":1,"sites\/all\/themes\/rub_news\/css\/62-node-article-left.css":1,"sites\/all\/themes\/rub_news\/css\/64-node-article-right.css":1,"sites\/all\/themes\/rub_news\/css\/66-node-article-flex.css":1,"sites\/all\/themes\/rub_news\/css\/68-node-article-flex-downloads.css":1,"sites\/all\/themes\/rub_news\/css\/70-node-serie-dossier-galerie-medien.css":1,"sites\/all\/themes\/rub_news\/css\/72-mensa.css":1,"sites\/all\/themes\/rub_news\/css\/74-redaktion-mitglieder.css":1,"sites\/all\/themes\/rub_news\/css\/76-user-profile.css":1,"sites\/all\/themes\/rub_news\/css\/80-node-standard.css":1,"sites\/all\/themes\/rub_news\/css\/82-node-standard-standard-left.css":1,"sites\/all\/themes\/rub_news\/css\/86-misc.css":1,"sites\/all\/themes\/rub_news\/css\/88-misc-ex-strat.css":1,"sites\/all\/themes\/rub_news\/css\/92-graceful-degradation.css":1,"sites\/all\/themes\/rub_news\/css\/99-dev.css":1,"sites\/all\/themes\/rub_news\/css\/100-web-cd.css":1,"sites\/all\/themes\/rub_news\/css\/user.css":1,"public:\/\/fontyourface\/local_fonts\/RUB_Nepo_Icons-normal-normal\/stylesheet.css":1}},"matomo":{"trackMailto":1},"radioactivity":{"emitters":{"emitDefault":{"cb34d467d69324fbb880156b02b19b31":{"accuracy":"100","bundle":"standard","energy":10,"entity_id":"9177","entity_type":"node","field_name":"field_radioactivity","language":"und","storage":"File","type":"none","checksum":"cb34d467d69324fbb880156b02b19b31"}}},"config":{"emitPath":"\/sites\/all\/modules\/radioactivity\/emit.php","fpEnabled":1,"fpTimeout":"5"}},"field_group":{"div":"full"}});</script>
    
  </head>
  
  <body class="html not-front not-logged-in no-sidebars page-node page-node- page-node-9177 node-type-standard i18n-de section-kultur-und-freizeit role-anonymous-user no-js "  >
    
    <div class="https://news.rub.de" id="base-url" style="display: none; visibility: hidden;"></div>

          <p id="skip-link">
        <a href="#main-menu" class="element-invisible element-focusable">Jump to navigation</a>
      </p>
    
        
<div id="header-wrapper">
  <div id="header-inner-wrapper">
    <div id="header-left">
      <div id="header-left-inner">
        <a href="http://www.ruhr-uni-bochum.de"><img class="rub-logo" src="https://news.rub.de/sites/all/themes/rub_news/logo.png" alt="Logo RUB"></a>
      </div>
    </div>
    
    <div id="header-center">
        <div class="region region-main-menu">
    <div id="block-system-main-menu" class="block block-system block-menu first last odd" role="navigation">

      
  <ul class="menu"><li class="menu__item is-leaf first leaf"><a href="https://www.ruhr-uni-bochum.de/de/informationen-zu-corona" target="_blank" class="menu__link">Corona-Infos</a></li>
<li class="menu__item is-leaf leaf"><a href="https://studium.ruhr-uni-bochum.de/de" class="menu__link">Studium</a></li>
<li class="menu__item is-leaf leaf"><a href="https://forschung.ruhr-uni-bochum.de/de" class="menu__link">Forschung</a></li>
<li class="menu__item is-leaf leaf"><a href="https://transfer.ruhr-uni-bochum.de/de" class="menu__link">Transfer</a></li>
<li class="menu__item is-leaf leaf"><a href="/" class="menu__link">News</a></li>
<li class="menu__item is-leaf leaf"><a href="https://uni.ruhr-uni-bochum.de/de" class="menu__link">Über uns</a></li>
<li class="menu__item is-leaf last leaf"><a href="https://einrichtungen.ruhr-uni-bochum.de/de" class="menu__link">Einrichtungen</a></li>
</ul>
</div>
  </div>
      <a id="nav-burger" href="#"></a> 
    </div>
    
    <div id="header-right">
      &nbsp;
    </div>
    
    <div class="clear"></div>
  </div>
</div>

<div id="nav-bg"></div>
<div id="subnav-bg"></div>

<div id="meta-menu-wrapper">
  <div id="sub-menu-and-content-wrapper" >
  
    <noscript>
      <div id="no-script-wrapper">
        <div id="no-script-inner"> 
          <span>Um diese Webseite vollumfänglich nutzen zu können, benötigen Sie JavaScript.</span><br /> 
          <a href="http://www.enable-javascript.com/de/" target="_blank">Hier finden Sie eine Anleitung, wie Sie JavaScript in Ihrem Browser einschalten.</a>
        </div>
      </div>
    </noscript>
  
    <div id="sub-menu">
      <div id="sub-menu-inner">
        
        <div id="menu-button">MENÜ</div>
        
                
        <ul class="menu rub-startseite">
          <li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
          <li class="menu__item is-leaf leaf" id="rub-star-item"><a href="http://www.rub.de" class="menu__link">RUB-STARTSEITE</a></li>
          <li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
        </ul>
        
          <div class="region region-sub-menu">
    <div id="block-menu-menu-sek-rmenu-newsportal" class="block block-menu first last odd" role="navigation">

      
  <ul class="menu"><li class="menu__item is-leaf first leaf" id="root-item"><a href="/" class="menu__link">News</a></li>
<li class="menu__item is-leaf leaf"><a href="/wissenschaft" class="menu__link">Wissenschaft</a></li>
<li class="menu__item is-leaf leaf"><a href="/studium" class="menu__link">Studium</a></li>
<li class="menu__item is-leaf leaf"><a href="/transfer" class="menu__link">Transfer</a></li>
<li class="menu__item is-leaf leaf"><a href="/leute" class="menu__link">Leute</a></li>
<li class="menu__item is-leaf leaf"><a href="/hochschulpolitik" class="menu__link">Hochschulpolitik</a></li>
<li class="menu__item is-leaf is-active-trail leaf active-trail"><a href="/kultur-und-freizeit" class="menu__link is-active-trail is-active active-trail active">Kultur und Freizeit</a></li>
<li class="menu__item is-leaf leaf"><a href="/vermischtes" class="menu__link">Vermischtes</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-collapsed collapsed"><a href="/servicemeldungen" class="menu__link">Servicemeldungen</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-leaf leaf"><a href="/serien" class="menu__link">Serien</a></li>
<li class="menu__item is-leaf leaf"><a href="/dossiers" class="menu__link">Dossiers</a></li>
<li class="menu__item is-leaf leaf"><a href="/bildergalerien" class="menu__link">Bildergalerien</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-expanded expanded" id="menu-item-pi"><a href="/presseinformationen" class="menu__link">Presseinformationen</a><ul class="menu"><li class="menu__item is-leaf first last leaf level-2"><a href="/presseinformationen/abo" class="menu__link">Abonnieren</a></li>
</ul></li>
<li class="menu__item is-expanded expanded"><a href="/rub-in-den-medien" class="menu__link">RUB in den Medien</a><ul class="menu"><li class="menu__item is-leaf first last leaf level-2"><a href="/rub-in-den-medien/abo" class="menu__link">Abonnieren</a></li>
</ul></li>
<li class="menu__item is-collapsed collapsed"><a href="/rubens" class="menu__link">Rubens</a></li>
<li class="menu__item is-expanded expanded"><a href="/rubin" class="menu__link">Rubin</a><ul class="menu"><li class="menu__item is-leaf first leaf level-2"><a href="/rubin/abo" class="menu__link">Abonnieren</a></li>
<li class="menu__item is-leaf last leaf level-2"><a href="/rubin/printarchiv" class="menu__link">Printarchiv</a></li>
</ul></li>
<li class="menu__item is-collapsed collapsed"><a href="/archiv" class="menu__link">Archiv</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-collapsed collapsed"><a href="/english" class="menu__link">English</a></li>
<li class="menu__item is-leaf leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
<li class="menu__item is-leaf leaf"><a href="/redaktion" class="menu__link">Redaktion</a></li>
<li class="menu__item is-leaf last leaf"><div class="menu__link separator"><div class="menu-separator-inner"></div></div></li>
</ul>
</div>
  </div>
        
        <a id="subnav-arrow" href="#"></a>
      </div>
    </div>
     
    <div id="content">
    
      <div id="content-inner">
        
              
        <div id="messages-wrapper">  
                  </div>

        <h1>Newsportal - Ruhr-Universität Bochum</h1>
        
                
                
        <a id="main-content"></a>
                        
        



<div  class="ds-2col node node-standard view-mode-full clearfix language-de">

  
  <div class="group-left">
    <div class="group-left-inner ">
      
  
        <div class="bildstrecke on-top flexslider">
          <ul class="slides">
            
          <li>
            <div class="flex bildstrecke-wrapper">
              <div class="bst-bild">
                <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/07_kita.jpg?itok=zFSUaTtI" width="804" height="536" alt="" />
              </div>
              <div class="bst-bu bildzeile-wrapper">
                <div class="bst-bu bildzeile-text">
                  <div>
	Dietmar Riemann ist ein Chronist der späten DDR. Unter anderem dokumentierte er den Alltag von Menschen mit geistigen Einschränkungen, sowohl von Kindern ...</div> 
                </div>
                <span class="bst-bu bildzeile-copyright">&copy;&nbsp;Dietmar Riemann</span>
              </div>
            </div>
          </li>
        
          <li>
            <div class="flex bildstrecke-wrapper">
              <div class="bst-bild">
                <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/06_einkauf.jpg?itok=6xhxGfCN" width="804" height="536" alt="" />
              </div>
              <div class="bst-bu bildzeile-wrapper">
                <div class="bst-bu bildzeile-text">
                  <div>
	... als auch von Erwachsenen.</div> 
                </div>
                <span class="bst-bu bildzeile-copyright">&copy;&nbsp;Dietmar Riemann</span>
              </div>
            </div>
          </li>
        
          <li>
            <div class="flex bildstrecke-wrapper">
              <div class="bst-bild">
                <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/03_baeckerei.jpg?itok=9NZg0XBl" width="804" height="536" alt="" />
              </div>
              <div class="bst-bu bildzeile-wrapper">
                <div class="bst-bu bildzeile-text">
                  <div>
	Bisweilen fällt Riemanns Kritik am Staat subtil aus, in diesem Fall präsentiert er ungeschönt den häufig herrschenden Mangel in der DDR.</div> 
                </div>
                <span class="bst-bu bildzeile-copyright">&copy;&nbsp;Dietmar Riemann</span>
              </div>
            </div>
          </li>
        
          <li>
            <div class="flex bildstrecke-wrapper">
              <div class="bst-bild">
                <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/09_schirme_0.jpg?itok=WpqghJOX" width="804" height="536" alt="" />
              </div>
              <div class="bst-bu bildzeile-wrapper">
                <div class="bst-bu bildzeile-text">
                  <div>
	Schlechtes Wetter gab es allerdings auch im Westen.</div> 
                </div>
                <span class="bst-bu bildzeile-copyright">&copy;&nbsp;Dietmar Riemann</span>
              </div>
            </div>
          </li>
        
          <li>
            <div class="flex bildstrecke-wrapper">
              <div class="bst-bild">
                <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/05_geburtstag.jpg?itok=z5N_Q2rC" width="804" height="536" alt="" />
              </div>
              <div class="bst-bu bildzeile-wrapper">
                <div class="bst-bu bildzeile-text">
                  <div>
	Genau wie Geburtstagsständchen.</div> 
                </div>
                <span class="bst-bu bildzeile-copyright">&copy;&nbsp;Dietmar Riemann</span>
              </div>
            </div>
          </li>
        
          </ul>
          
      <div class="slider-counter">
        <span class="current">&nbsp;</span> <span class="von">/</span> <span class="total">&nbsp;</span>
      </div>
    
        </div>
      
<div class="content-inner-inner-wrapper">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Fotografie</div>
      </div>
</div>

  <h2 class="field-std-headline">
    Neue Bilder für die Stiftung Situation Kunst  </h2>

  <div class="field-std-teaser">
    <p>Der Fotograf Dietmar Riemann hat ihr sein gesamtes Werk geschenkt. Studierende sichten nun die Fotos.</p>
  </div>

  <div class="field-std-text">
    <p>Dietmar Riemann hat der <a target="_blank" href="https://situation-kunst.de/stiftung">Stiftung Situation Kunst</a> – und damit auch der Ruhr-Universität – im Mai 2022 sein gesamtes fotografisches Werk geschenkt: Fotografien, die seit den späten Siebzigerjahren in der DDR entstanden sind. Vor allem ab 1986, als Riemann mit seiner Familie einen erst im September 1989 positiv beschiedenen Ausreiseantrag gestellt hatte, wurde er zum aufmerksamen Chronisten seines Lebensumfelds. Er hielt es in beeindruckenden, oft bedrückenden, aber immer auch menschlich berührenden Bildern fotografisch fest.</p>
<h4>
	Motive mit enormer Sprengkraft</h4>
<p>Seine Motive sind vielfältig und umfassen unter anderem Serien von Schaufenstern, Mauern und Zäunen, Hinterhöfen, Porträts der Menschen aus seiner Umgebung und das Freizeitvergnügen auf der Trabrennbahn. Die Motive erscheinen zunächst alltäglich, besaßen aber aufgrund ihrer subtil kritischen Codierung enorme Sprengkraft. Riemann eckte damit an, zum Beispiel mit der Reihe „Geistig behindert“ (1986 unter dem Titel „Was für eine Insel in was für einem Meer“ als Fotobuch im Hinstorff Verlag erschienen), in der er Menschen mit geistigen Einschränkungen und ihren Alltag in den Blick nimmt.</p>
<p>Gleichzeitig ermöglichen die Fotos neben der ungeschönten Dokumentation des Alltags in der DDR und später in der BRD ein Nachdenken über zeitlose Themen wie Freiheit, zwischenmenschliche Beziehungen sowie Krankheit und Tod.</p>

            <div class="flex zitat-wrapper">
              <div class="zitat-text">
                <p>Natürlich können wir es kaum erwarten, diese großartigen Fotografien auszustellen.</p>
              </div>
              
              <div class="zitat-quelle">
                &ndash; Eva Wruck
              </div>
            
            </div>
          
<p>„Die Stiftung Situation Kunst freut sich riesig über die großzügige Schenkung des Gesamtwerks von Dietmar Riemann“, sagt Eva Wruck. Sie ist Kuratorin von <a target="_blank" href="https://situation-kunst.de/situation-kunst">Situation Kunst</a>, zu der auch das Museum unter Tage gehört. „Natürlich können wir es kaum erwarten, diese großartigen Fotografien auszustellen. Zunächst aber müssen wir die Schenkung aufarbeiten.“</p>
<p>Hier kommt die Besonderheit von Situation Kunst zu tragen: Ein Team von studentischen Beschäftigten ist unter Leitung von Eva Wruck intensiv in den Prozess der Inventarisierung eingebunden. Von der Sichtung der Schenkung über die Katalogisierung und Erfassung in einer Datenbank bis hin zur Einlagerung können die Studierenden wertvolle praxisbezogene Erfahrungen sammeln.</p>
  </div>
</div>    </div>
  </div>

  <div class="group-right">
    <div class="group-right-inner">
      
  <div class="field-test">
    
      <div class="published-wrapper">
        <div class="published-label">Veröffentlicht</div>
        Freitag<br />12. August 2022<br />10.44 Uhr
      </div>
    

  </div>

  <div class="field-urheber-custom-">
    
    <div class="urheber-wrapper">
      <div class="urheber-label">Von</div>
      <a href="/redaktion/arne-dessaul-ad">Arne Dessaul (ad)</a>
      
    </div>
    </div>
<div class="shariff-wrapper"><div class="label-above lang-en">Share</div><div class="label-above lang-de">Teilen</div><div class="shariff"  data-mail-body="Hallo,
  
diesen Artikel habe ich im Newsportal der Ruhr-Universität Bochum gefunden:

https://news.rub.de/kultur-und-freizeit/2022-08-12-fotografie-neue-bilder-fuer-die-stiftung-situation-kunst

Viele Grüße!

- - -

Alle News rund um die Ruhr-Universität Bochum: http://news.rub.de"  data-title="Fotografie: Neue Bilder für die Stiftung Situation Kunst -" data-services="[&quot;twitter&quot;,&quot;facebook&quot;,&quot;whatsapp&quot;,&quot;mail&quot;]" data-theme="grey" data-orientation="vertical" data-twitter-via="ruhrunibochum" data-mail-url="mailto:" data-mail-subject="Artikelempfehlung: Neue Bilder für die Stiftung Situation Kunst – news.rub.de" data-lang="de" data-url="https://news.rub.de/kultur-und-freizeit/2022-08-12-fotografie-neue-bilder-fuer-die-stiftung-situation-kunst"></div></div>    </div>
  </div>

</div>

   
  
      <div class="teaser-box triple">
        <div class="teaser-box-header">Das könnte Sie auch interessieren</div>
          <div class="item item-1"><a href="/kultur-und-freizeit/2022-06-09-veranstaltung-neue-werke-fuer-die-kunstsammlungen" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2022_06_09_kusa_schenkung_kusa.jpg?itok=pG7hq6EO" width="804" height="536" alt="Ausstellungsplakat" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Veranstaltung</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Neue Werke für die Kunstsammlungen  
</h2>
          </div>
        </div>
      </a></div><div class="item item-2"><a href="/kultur-und-freizeit/2022-07-04-preis-verliehen-klaus-sievers-gewinnt-den-5-fbz-art-award" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2022_06_30_kunstpreis_sievers_fbz.jpg?itok=3Zc4MxEi" width="804" height="536" alt="Klaus Sievers vor einem Ausschnitt seines prämierten Werks" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Preis verliehen</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Klaus Sievers gewinnt den 5. FBZ art award  
</h2>
          </div>
        </div>
      </a></div><div class="item item-3"><a href="/kultur-und-freizeit/2022-06-02-walk-diversity-diversitaet-wird-der-rub-gross-geschrieben" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2022_06_02_diversity_regenbogen_tk.jpg?itok=UWobrhO8" width="804" height="536" alt="Regenbogenfahne" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Walk of Diversity</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Diversität wird an der RUB groß geschrieben  
</h2>
          </div>
        </div>
      </a></div>
        <div class="clear"></div>
      </div>
      
  
      <div class="teaser-box triple">
        <div class="teaser-box-header">Derzeit beliebt</div>
          <div class="item item-1"><a href="/wissenschaft/2022-09-07-psychologie-sportrunde-drehen-statt-social-media-story-sehen" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2020_02_19_km_laufen-9.jpg?itok=1sB480zj" width="804" height="536" alt="Läuferin" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Psychologie</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Sportrunde drehen statt Social-Media-Story sehen  
</h2>
          </div>
        </div>
      </a></div><div class="item item-2"><a href="/wissenschaft/2019-12-10-religion-existiert-gott" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/goecke_benedikt_km-3.jpg?itok=f278wErc" width="804" height="536" alt="Benedikt Göcke, Blue Square, Veranstaltung" />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Religion</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Existiert Gott?  
</h2>
          </div>
        </div>
      </a></div><div class="item item-3"><a href="/hochschulpolitik/2022-09-09-erstes-alumni-treffen-erfolgreich-ueber-die-studienbruecke-gegangen" class="hover-layer">
        
        <div class="img-wrapper">
          <div class="img-wrapper-inner">
            
  
    <img src="https://news.rub.de/sites/default/files/styles/nepo_teaser/public/2022_09_08_km_studienbruecke_-9.jpg?itok=w3PSJAZ3" width="804" height="536" alt="Santiago Soares aus Brasilien, Sofia Kostiukovska aus der Ukraine und Miles Lunger aus den USA (von links) sind drei junge Menschen, die stellvertretend für die vielen Studienbrücklerinnen und -brückler aus alller Welt stehen." />  
 
            
          </div>
        </div>
      
        <div class="article-info-wrapper">
          <div class="article-info-wrapper-inner">
            <div class="dachzeile">
<div class="field-std-dachzeile">
    <div class="field-items">
          <div class="field-item even">Erstes Alumni-Treffen</div>
      </div>
</div>
</div>
            <h2 class="headline">
  
    Erfolgreich über die Studienbrücke gegangen  
</h2>
          </div>
        </div>
      </a></div>
        <div class="clear"></div>
      </div>
      
   
    
    <div class="button-further-article-wrapper ressort kultur-und-freizeit">
      <div class="button-further ressort">
        <a href="/kultur-und-freizeit" class="hover-layer">
    
    <div class="img-wrapper">
      <div class="img-wrapper-inner">
        &nbsp;
      </div>
    </div>
  
    <div class="article-info-wrapper">
      <div class="article-info-wrapper-inner">
        <div class="headline">Mehr Kultur und Freizeit</div>
        <div class="button-arrow-wrapper no-link">
          <span class="button-arrow-arrow"><!-- --></span>
          <span class="button-arrow-text">Ressort</span>
        </div>
      </div>
    </div>
    <div class="clear"></div>
  </a>
      </div>
    </div>
    

 
  <div class="last-child">
           
    <div class="button-further-article-wrapper">
      <div class="button-further start">
        <a href="https://news.rub.de" class="hover-layer">
    
    <div class="img-wrapper">
      <div class="img-wrapper-inner">
        &nbsp;
      </div>
    </div>
  
    <div class="article-info-wrapper">
      <div class="article-info-wrapper-inner">
        <div class="headline">Zur Startseite</div>
        <div class="button-arrow-wrapper no-link">
          <span class="button-arrow-arrow"><!-- --></span>
          <span class="button-arrow-text">News</span>
        </div>
      </div>
    </div>
    <div class="clear"></div>
  </a>
      </div>
    </div>
        </div>




<div id="block-menu-menu-metamenu-nepo" class="block block-menu last even" role="navigation">

      
  <ul class="menu"><li class="menu__item is-leaf first leaf blue"><a href="http://www.ruhr-uni-bochum.de/a-z/" title="Zum A-Z" target="_blank" class="menu__link">A-Z</a></li>
<li class="menu__item is-leaf leaf blue" id="button-contrast-meta"><a href="/" title="Kontrast" class="menu__link">N</a></li>
<li class="menu__item is-leaf leaf green newsfeed"><a href="/newsfeed" title="Newsfeed" target="_blank" class="menu__link">K</a></li>
<li class="menu__item is-leaf leaf green social-fb"><a href="https://www.facebook.com/RuhrUniBochum" title="RUB bei Facebook" target="_blank" class="menu__link"></a></li>
<li class="menu__item is-leaf leaf green social-tw"><a href="http://twitter.com/ruhrunibochum" title="RUB bei Twitter" target="_blank" class="menu__link"></a></li>
<li class="menu__item is-leaf last leaf green social-ig"><a href="http://instagram.com/ruhrunibochum" title="RUB bei Instagram" target="_blank" class="menu__link"></a></li>
</ul>
</div>
      
      </div>
    </div>

    <div class="clear"></div>
  </div>
</div>


<div id="pre-footer-wrapper">
  </div>  


<div id="footer-wrapper">
  <div id="footer-inner-wrapper">
    <div id="footer-left">
      <div id="footer-left-inner">
        <a href="http://www.ruhr-uni-bochum.de"><img class="rub-logo" src="https://news.rub.de/sites/all/themes/rub_news/logo.png" alt="Logo RUB"></a>
        
        <div class="footer-text impressum impressum-logo">
          <a href="http://www.ruhr-uni-bochum.de/impressum.htm">Impressum</a> |
          <a href="http://www.ruhr-uni-bochum.de/kontakt">Kontakt</a>
        </div>
        
      </div>
    </div>
    
    <div id="footer-right">
      <div id="footer-right-inner">
              

        <div class="footer-text left">
          <div><strong>Ruhr-Universität Bochum</strong></div>
          Universitätsstraße 150<br />
          44801 Bochum<br /><br />
          <a target="_blank" href="https://www.ruhr-uni-bochum.de/de/datenschutzhinweise">Datenschutz</a><br />
          <a target="_blank" href="https://www.ruhr-uni-bochum.de/de/barrierefreiheit">Barrierefreiheit</a><br />
          <a target="_blank" href="http://www.ruhr-uni-bochum.de/impressum.htm">Impressum</a>
        </div>
        <div class="footer-text center-left">
          <div><strong>Schnellzugriff</strong></div>
          <a target="_blank" href="http://uni.ruhr-uni-bochum.de/de/service-und-themen">Service und Themen</a><br />
          <a target="_blank" href="http://www.rub.de/anreise">Anreise und Lagepläne</a><br />
          <a target="_blank" href="https://notfall.rub.de/">Hilfe im Notfall</a><br />
          <a target="_blank" href="https://uni.ruhr-uni-bochum.de/de/stellenangebote">Stellenangebote</a><br />
        </div>
        <div class="footer-text center-right">
          <div><strong>Social Media</strong></div>
          <a target="_blank" href="https://www.facebook.com/RuhrUniBochum">Facebook</a><br />
          <a target="_blank" href="https://twitter.com/ruhrunibochum">Twitter</a><br />
          <a target="_blank" href="https://www.youtube.com/user/ruhruniversitaet/">YouTube</a><br />
          <a target="_blank" href="https://instagram.com/ruhrunibochum">Instagram</a><br />
        </div>
        <div class="footer-text right">
          <div class="right-inner">
            <a href="#" id="button-to-top">Seitenanfang <span class="arrow-up">y</span></a>
            <a href="#" id="button-contrast">Kontrast <span class="arrow-up">N</span></a>
          </div>
        </div>
        <div class="clear"></div>
        
        <div class="footer-text impressum impressum-small">
          <a target="_blank" href="http://www.ruhr-uni-bochum.de/impressum.htm">Impressum</a> |
          <a target="_blank" href="http://www.ruhr-uni-bochum.de/kontakt">Kontakt</a>
        </div>
        
      </div>
    </div>
    
    <div class="clear"></div>
  </div>
</div>
    <script>var _paq = _paq || [];(function(){var u=(("https:" == document.location.protocol) ? "https://statistic.ruhr-uni-bochum.de/" : "https://statistic.ruhr-uni-bochum.de/");_paq.push(["setSiteId", "3"]);_paq.push(["setTrackerUrl", u+"matomo.php"]);_paq.push(["setDoNotTrack", 1]);_paq.push(["disableCookies"]);_paq.push(["trackPageView"]);_paq.push(["setIgnoreClasses", ["no-tracking","colorbox"]]);_paq.push(["enableLinkTracking"]);var d=document,g=d.createElement("script"),s=d.getElementsByTagName("script")[0];g.type="text/javascript";g.defer=true;g.async=true;g.src=u+"matomo.js";s.parentNode.insertBefore(g,s);})();</script>
<script src="https://news.rub.de/sites/all/libraries/shariff/build/shariff.min.js?rganwc"></script>
    
        
    
  </body>
</html>
''';

const String rubnewsTestNewsurl1 =
    'https://news.rub.de/wissenschaft/2022-09-09-biopsychologie-schlaue-voegel-denken-smart-und-sparsam';

const String rubnewsTestNewsurl2 =
    'https://news.rub.de/kultur-und-freizeit/2022-08-12-fotografie-neue-bilder-fuer-die-stiftung-situation-kunst';

/// Test XML Response data for newsfeed by RUB news from 11.09.2022, ~09:15 a.m.
const String rubnewsTestsDataSuccess = '''
<?xml version="1.0" encoding="utf-8" ?> <rss version="2.0" xml:base="https://news.rub.de/" xmlns:atom="http://www.w3.org/2005/Atom"> <channel> <title>Newsportal - Ruhr-Universität Bochum</title>
 <description>Die neuesten Nachrichten und Meldungen der Ruhr-Universität Bochum.</description>
 <link>https://news.rub.de/</link>
 <atom:link rel="self" href="https://news.rub.de/newsfeed" />
 <language>de-de</language>
 <copyright>Ruhr-Universität Bochum, Dezernat Hochschulkommunikation</copyright>
 <pubDate>Fri, 09 Sep 2022 10:36:37 +0200</pubDate>
 <lastBuildDate>Fri, 09 Sep 2022 13:03:33 +0200</lastBuildDate>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;Die Gehirnzellen von Vögeln benötigen nur etwa ein Drittel der Energie, die Säugetiere aufwenden müssen, um ihr Gehirn zu versorgen. „Das erklärt zum Teil, wie Vögel es schaffen, so schlau zu sein, obwohl ihre Gehirne so viel kleiner sind als die von Säugetieren“, sagt Prof. Dr. Onur Güntürkün, Leiter der Arbeitseinheit Biopsychologie der RUB. Sein Forschungsteam untersuchte gemeinsam mit Kolleginnen und Kollegen aus Köln, Jülich und Düsseldorf den Energieverbrauch der Gehirne von Tauben mit bildgebenden Methoden. Die Forschenden berichten in der Zeitschrift Current Biology vom 8. September 2022.&lt;/p&gt;
&lt;h4&gt;
	Warum es eine Krähe mit einem Schimpansen aufnehmen kann&lt;/h4&gt;
&lt;p&gt;Unser Gehirn macht nur etwa zwei Prozent unseres Körpergewichts aus, verbraucht aber etwa 20 bis 25 Prozent der Körperenergie. „Das Gehirn ist damit das mit Abstand energetisch teuerste Organ unseres Körpers, und wir konnten es uns im Laufe der Evolution nur leisten, indem wir uns erfolgreich sehr viel Energie zuzuführen lernten“, erklärt Güntürkün. Die Gehirne von Vögeln sind im Vergleich viel kleiner. Trotzdem sind Vögel genauso schlau wie so manche Säuger: Krähen und Papageien zum Beispiel, deren Gehirne nur etwa 10 bis 20 Gramm wiegen, können es kognitiv durchaus mit einem Schimpansen aufnehmen, dessen Gehirn 400 Gramm auf die Waage bringt.&lt;/p&gt;
&lt;p&gt;Güntürkün und sein Team die Gehirne von Tauben genauer unter die Lupe. Dafür nutzten sie die Methode der Positronen-Emissions-Tomografie, kurz PET. Dank eines speziellen Kontrastmittels konnten sie anhand der damit erzielten Bilder abschätzen, wie viel Glukose die Nervenzellen im Gehirn der Tauben im wachen und im narkotisierten Zustand jeweils verbrauchten. Der Energieverbrauch betrug demnach nur ein Drittel dessen, was ein Säugetiergehirn verbraucht.&lt;/p&gt;
&lt;p&gt;&quot;Dass der Unterschied so groß ist, bedeutet, dass Vögel zusätzliche Mechanismen besitzen, die den Energieverbrauch der Nervenzellen senken. Das könnte zum Teil mit der höheren Körpertemperatur von Vögeln zusammenhängen, aber wahrscheinlich auch mit zusätzlichen Faktoren, die derzeit noch völlig unbekannt sind“, erklärt der Forscher. „Unsere Studie fügt sich in eine wachsende Zahl von Studien ein, die zeigen, dass Vögel in der Evolution einen eigenen und sehr erfolgreichen Weg zur Entstehung intelligenter Gehirne entwickelt haben.“&lt;/p&gt;
&lt;p&gt;[infobox:1]&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Schlaue Vögel denken smart und sparsam</title>
 <link>https://news.rub.de/wissenschaft/2022-09-09-biopsychologie-schlaue-voegel-denken-smart-und-sparsam</link>
 <description>
  
    Gegenüber der Energieeffizienz von Vogelgehirnen können wir Säugetiere einpacken.
  
</description>
 <guid isPermaLink="false">rub-newportal-9242</guid>
 <pubDate>Fri, 09 Sep 2022 09:11:52 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;Rund 80 Alumni des internationalen Programms Studienbrücke haben sich am 7. September 2022 an der RUB zum Austausch und Wiedersehen getroffen. Über das Programm studieren hoch engagierte und qualifizierte junge Menschen aus Osteuroapea – Russland, Ukraine und Belarus – sowie weiteren Regionen der Welt an deutschen Partnerhochschulen. Die Nachfrage ist hoch und das Programm läuft unvermindert weiter.&lt;/p&gt;
&lt;p&gt;[zitat:1]&lt;/p&gt;
&lt;p&gt;Seit dem Beginn des Angriffskriegs Russlands auf die Ukraine im Februar 2022 wurden die aktiven Beziehungen zu staatlichen russischen Einrichtungen auf Eis gelegt. Das gilt jedoch nicht für studienvorbereitende Programme, die einen Weg ins Studium an deutsche Universitäten ermöglichen. Zu den erfolgreichsten Programmen dieser Art gehört die Studienbrücke. „Wir sehen heute, dass es richtig war, das Programm weiterlaufen zu lassen“, freut sich Prof. Dr. Martin Paul, Rektor der RUB. „Der rege Zuspruch und die Nachfrage aus ganz Osteuropa bekräftigen das. Die Studienbrücke steht für Zusammenhalt, für Hilfsbereitschaft und Solidarität. Ganz besonders die Studierenden aus Russland und der Ukraine, die zu uns kommen, halten in diesen schwierigen Zeiten zusammen und interagieren mit den Studierenden aus anderen Zielländern der Studienbrücke.“&lt;/p&gt;
&lt;p&gt;[infobox:1]&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Erfolgreich über die Studienbrücke gegangen</title>
 <link>https://news.rub.de/hochschulpolitik/2022-09-09-erstes-alumni-treffen-erfolgreich-ueber-die-studienbruecke-gegangen</link>
 <description>
  
    Seit acht Jahren schlägt das Austauschprogramm eine „Studienbrücke“ nach Osteuropa. Die RUB hat das erste Wiedersehen der Brücklerinnen und Brückler auch in schwierigen Zeiten ermöglicht.
  
</description>
 <guid isPermaLink="false">rub-newportal-9286</guid>
 <pubDate>Fri, 09 Sep 2022 12:57:59 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;„Bochum ist eine kleine Stadt, aber das finde ich sehr gemütlich und ich kann bestimmt trotzdem viel entdecken“, sagt Salomé Toussaint an ihrem ersten Tag an der RUB. Für die Pariserin wirkt wahrscheinlich jede andere Stadt klein. Sie gehört zu den 37 Stipendiaten und Stipendiatinnen aus Frankreich, die am „Programme d’Etudes en Allemange“ (PEA) teilnehmen. Bei der Eröffnungsveranstaltung am 7. September 2022 begrüßte der französische Hochschulattaché Dr. Matthieu Osmont die Teilnehmenden. „Diese Studierenden sind die Zukunft“, betonte er und hob die Besonderheit der deutsch-französischen Zusammenarbeit hervor.&lt;/p&gt;
&lt;p&gt;Auch hieß das Romanische Seminar, vertreten durch Dr. Judith Kittler, die Gruppe herzlich willkommen. Während des Aufenthalts an der RUB bis Januar 2023 besuchen die Gäste diverse Kurse, zunächst Kompaktseminare. Mit Semesterbeginn nehmen sie an regulären Veranstaltungen an der RUB teil. Durch den eigenen Projektkurs „Face à Face“ trainieren die französischen und deutschen Studierenden die Sprache sowie die interkulturellen Kompetenzen. Salomé Toussaint sagt: „Ich wollte schon immer in Deutschland studieren. Es war schon immer mein Traum, der jetzt wahrgeworden ist.“&lt;/p&gt;
&lt;p&gt;[zitat:1]&lt;/p&gt;
&lt;p&gt;Die Programmbeauftragte Dr. Nathalie Piquet zeigte sich sehr erfreut über die neue Gruppe: „Es sind für die Studierenden immer fünf magische Monate an der RUB.“ Ein neues Land kennenzulernen und auch die Kultur wird innerhalb des Programms mit unterschiedlichen Exkursionen wie zum Beispiel ins Bergbaumuseum Bochum, zum VfL-Stadion oder einer dreitägigen Reise nach Berlin ermöglicht.&lt;/p&gt;
&lt;p&gt;Unterstützt werden die Stipendiatinnen und Stipendiaten durch ein Programm des Deutschen Akademischen Austauschdienstes (DAAD). Studierende mit besonderen Qualifikationen und Engagement bewerben sich, um ihr drittes Semester in Bochum zu verbringen. Das DAAD-Büro in Paris wählt die Teilnehmenden aus und unterstützt diese mit 360 Euro pro Monat. Zusätzliche Kosten für das rahmengebende Programm werden ebenfalls übernommen. Seit rund 20 Jahren findet der deutsch-französische Austausch statt. Die RUB ist mittlerweile die einzige Partnerhochschule dieses DAAD-Programms.&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Ein „Bonjour“ vom Hochschulattaché</title>
 <link>https://news.rub.de/studium/2022-09-09-internationales-ein-bonjour-vom-hochschulattache</link>
 <description>
  
    Monsieur Osmont begrüßte 37 Studierende aus Frankreich, die fortan den Campus der RUB internationaler machen.
  
</description>
 <guid isPermaLink="false">rub-newportal-9284</guid>
 <pubDate>Fri, 09 Sep 2022 10:16:53 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;Im neuen Promotionskolleg Mit Sprache – Mitbestimmung durch SprachGewalten werden sich zwölf Doktorandinnen und Doktoranden damit auseinandersetzen, welche Auswirkungen Sprache in und auf Mitbestimmungsprozesse hat. Im Fokus stehen dabei sogenannte Sprachgewalten und sprachliche Gewalten. Beispiele für sprachliche Gewalt sind Beleidigungen. Sprachgewalt umfasst eher Aspekte der Sprachkompetenz und des Wissens über Sprache. Beide Begriffe werden für das Promotionskolleg als SprachGewalten zusammengefasst.&lt;/p&gt;
&lt;p&gt;Das Promotionskolleg hat zum Ziel, die Beziehung von Mitbestimmung und SprachGewalten vor dem Hintergrund fortschreitender gesellschaftlicher, arbeitsweltlicher und digitaler Veränderungen zu untersuchen.&lt;/p&gt;
&lt;h4&gt;
	Förderung&lt;/h4&gt;
&lt;p&gt;Die Hans-Böckler-Stiftung fördert das neue Promotionskolleg, das im November 2022 seine Arbeit aufnehmen wird. Die Förderung läuft insgesamt drei Jahre. Die Ausschreibung für die Postdoktoranden-Stelle und Promotionstipendien erfolgt im Herbst 2022, Interessierte erhalten Informationen bei &lt;a href=&quot;http://staff.germanistik.rub.de/rothstein/&quot;&gt;Prof. Dr. Björn Rothstein&lt;/a&gt;.&lt;/p&gt;
&lt;h4&gt;
	Interdisziplinäre Forschungsarbeit&lt;/h4&gt;
&lt;p&gt;Die Analyse der systematischen, angewandten und erwerbs- beziehungsweise lernbedingten Aspekte menschlicher Sprachen verlangt unterschiedliche methodologische Verfahren, die etwa von medialen sprachlichen Darbietungen und unter anderem von arbeitsweltlichen, bildungsinstitutionellen und sozialen Kommunikationskontexten abhängig sind. Im Kolleg kommen daher Aspekte aus den Disziplinen Linguistik, Arbeits-, Bildungs-, Kommunikations-, Medien-, Sozial- und Geschichtswissenschaften zusammen.&lt;/p&gt;
&lt;p&gt;Als Betreuende beteiligt sind Gabrielle Bellenberg (Schulpädagogik), Anastasia Drackert (Test-DaF), Eric Fuß (Germanistik), Karim Fereidooni (Sozialwissenschaft), Markus Hertwig (Arbeitswissenschaft), Hannes Krämer (Kommunikationswissenschaft/ Universität Duisburg-Essen), Laura Morgenthaler García (Romanistik), Klaus Oschema (Geschichtswissenschaft), Anna Tuschling (Medienwissenschaft), Tatjana Scheffler (Digitale forensische Linguistik), Sven Thiersch (Schulische Sozialisationsforschung/Universität Osnabrück) und Judith Visser (Romanistik). Sprecher ist Björn Rothstein (Germanistik).&lt;/p&gt;
&lt;p&gt;So bildet das Kolleg eine interdisziplinäre Grundlage für die Forschungsfragen, die bearbeitet werden, und ergänzt das Angebot zur wissenschaftlichen Nachwuchsförderung am Hochschulstandort Ruhrgebiet. Außerdem ergänzt das Promotionskolleg die Strukturbildungsmaßnahmen der RUB im Bereich der Geisteswissenschaften, die die Vernetzung geisteswissenschaftlicher Institutionen untereinander und über Fächergrenzen hinaus zum Ziel haben.&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Neues Promotionskolleg an der RUB</title>
 <link>https://news.rub.de/wissenschaft/2022-09-08-geisteswissenschaften-neues-promotionskolleg-der-rub</link>
 <description>
  
    Für mehr Nachwuchsförderung in den Geisteswissenschaften: Zwölf Stipendien und eine Postdoktoranden-Stelle sind zu vergeben.
  
</description>
 <guid isPermaLink="false">rub-newportal-9276</guid>
 <pubDate>Thu, 08 Sep 2022 13:22:00 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;Der Einsatz von Techniken des maschinellen Lernens und der Künstlichen Intelligenz (KI) verändert nicht nur die Arbeitswelt in der Industrie, sondern ebenfalls den Forschungsalltag. Die mathematische Grundlagenforschung kommt einem dabei vielleicht nicht als erstes als Anwendungsgebiet in den Sinn. Und tatsächlich sind die mit KI verbundenen Veränderungen der Forschungswelt bisher weitestgehend an der Mathematik vorbeigegangen.&lt;/p&gt;
&lt;p&gt;Ich denke aber, das wird nicht so bleiben.&lt;/p&gt;
&lt;p&gt;Auch wenn dieser Ansatz noch nicht etabliert ist, werden KI-Methoden bereits erfolgreich in der mathematischen Grundlagenforschung angewandt. Zum einen suchen Mathematikerinnen und Mathematiker eigentlich immer nach guten Beispielen für ihre Theorien. Wenn ich eine Theorie für Objekte im dreidimensionalen Raum entwickle, sollte ich diese zumindest einmal an den Platonischen Körpern testen; das sind fünf Körper, zu denen beispielsweise Würfel oder Tetraeder gehören. Mit dem Computer könnte man unzählige Beispiele generieren und jedem Beispiel einen „Wie-gut-ist-dieses-Beispiel-für-mich-geeignet“-Wert zuweisen. Dieser Wert liefert dann einen perfekten Ansatz für Methoden der KI, um aus den generierten Beispielen die für mich interessanten herauszufiltern. Das kann eine KI vielleicht sogar besser als ich.&lt;/p&gt;
&lt;p&gt;Zum anderen, und das ist etwas subtiler, gibt es erste Situationen, in denen KI im Kern der Forschung genutzt wurde, der eigentlich erst durch menschliche Intuition und Kreativität möglich wird. Im Jahr 2021 in der Zeitschrift Nature veröffentlichte Ergebnisse in dieser Richtung haben Mathematikerinnen und Mathematiker weltweit aufhorchen lassen. Darin wurden wichtige und kreative Fortschritte in seit vielen Jahren offenen Forschungsfragen erzielt. Die KI hat Zusammenhänge erkannt, die Expertinnen und Experten zuvor noch nicht gefunden hatten.&lt;/p&gt;
&lt;p&gt;[zitat:1]&lt;/p&gt;
&lt;p&gt;Wir stehen also am Anfang einer sich abzeichnenden Veränderung in den Forschungsabläufen. Aber eben auch nur an den Abläufen. Eine KI wird die mathematische Grundlagenforschung nicht ersetzen. Im unendlichen Universum aller mathematischen Theoreme suchen wir nach den relevanten, tiefsinnigen, anwendbaren Theoremen. Allerdings sind die allermeisten Theoreme irrelevant oder banal oder weniger spannend als andere.&lt;/p&gt;
&lt;p&gt;Das Theorem „7+4=11“ ist eben irrelevant und banal. Und das Theorem „Der Würfel hat 8 Ecken, 12 Kanten und 6 Seitenflächen“ ist weniger spannend als das Theorem „Für beliebige Objekte im dreidimensionalen Raum ohne Löcher mit Ecken, Kanten und Seitenflächen ergibt die Anzahl der Ecken plus Anzahl der Flächen minus Anzahl der Kanten immer 2.“ (Probieren Sie das einmal an den Platonischen Körpern aus! Und falls Ihnen das zu einfach ist, zerlegen Sie die Oberfläche von einem Donut – natürlich nur auf dem Papier – in Drei- oder Vierecke. Dann werden Sie statt 2 immer 0 herausbekommen.) Wenn man eine KI mit den richtigen Daten füttert, kann diese solche Eigenschaften herausfinden.&lt;/p&gt;
&lt;p&gt;Aber eine KI wird niemals entscheiden können, ob diese Eigenschaft relevant oder tiefsinnig oder anwendbar ist. Und sie kann auch nicht selbstständig herausfinden, warum diese Eigenschaft universal für alle Objekte gültig ist.&lt;/p&gt;
&lt;p&gt;[infobox:2]&lt;/p&gt;
&lt;p&gt;[infobox:1]&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Künstliche Intelligenz forschen lassen?</title>
 <link>https://news.rub.de/wissenschaft/2022-09-09-standpunkt-kuenstliche-intelligenz-forschen-lassen</link>
 <description>
  
    In der Mathematik haben Algorithmen Zusammenhänge entdeckt, die Expertinnen und Experten zuvor verborgen geblieben waren. Kein Grund, die Füße hochzulegen und mit der Forschung aufzuhören, meint Christian Stump.
  
</description>
 <guid isPermaLink="false">rub-newportal-9232</guid>
 <pubDate>Fri, 09 Sep 2022 09:13:00 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;Die Online-Seminarreihe „How to transfer“ bietet wieder Seminare und Informationsmöglichkeiten an, um im Wissenschaftstransfer erfolgreich zu sein. Der Schwerpunkt liegt auf den Themenfeldern Wissenschaftskommunikation und Verwertung. Vom 12. bis 23. September 2022 werden die Veranstaltungen der Seminarreihe angeboten. Das Angebot umfasst Veranstaltungen in deutscher und englischer Sprache.&lt;/p&gt;
&lt;p&gt;Themenbereiche sind unter anderem:&lt;/p&gt;
&lt;ul&gt;
	&lt;li&gt;
		Einblick in die Vielfalt der Verwertung – welche Möglichkeiten gibt es und welcher Verwertungsweg ist der geeignete für Ihre Forschungsergebnisse?&lt;/li&gt;
	&lt;li&gt;
		Weiterbildung als Möglichkeit zum Wissenstransfer&lt;/li&gt;
	&lt;li&gt;
		Neue Anwendungsfelder und Zielgruppen für Ihre Forschung identifizieren – lernen sie einen systematischen Ansatz kennen, wie sie hierbei vorgehen.&lt;/li&gt;
	&lt;li&gt;
		Normung oder Patent? – wer sich hier auskennt, kann strategisch für seine Forschung entscheiden. Auch für die Geisteswissenschaften von Interesse!&lt;/li&gt;
&lt;/ul&gt;
&lt;p&gt;Einen ausführlichen Überblick über das Programm mit Beschreibungen der Seminare gibt es im &lt;a href=&quot;https://serviceportal.ruhr-uni-bochum.de/Begriffesammlung/Seiten/WORLDFACTORY-How-to-transfer.aspx?term=Forschung%20%EF%BC%86%20Transfer%3BSeminare%20%EF%BC%86%20Veranstaltungen&quot; target=&quot;_blank&quot;&gt;Serviceportal&lt;/a&gt;. Die Seminare können auch einzeln gebucht werden und eine Anmeldung ist im Serviceportal bis zum jeweiligen Veranstaltungstag möglich.&lt;/p&gt;
&lt;p&gt;[infobox:1]&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Wissenschaftstransfer leicht gemacht</title>
 <link>https://news.rub.de/transfer/2022-09-09-seminarreihe-wissenschaftstransfer-leicht-gemacht</link>
 <description>
  
    Das Online-Angebot steht für RUB-Wissenschaftler und Wissenschaftlerinnen zur Verfügung.
  
</description>
 <guid isPermaLink="false">rub-newportal-9272</guid>
 <pubDate>Fri, 09 Sep 2022 13:03:33 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;Weltweit werden jedes Jahr etwa 20 Millionen Tonnen Lösungsmittel verbraucht, von denen bisher nur ein kleiner Teil biobasiert hergestellt wird. Ein internationales Projektteam möchte mit Dimethylfuran eine Alternative zu etablierten Lösungsmitteln bereitstellen. Der Stoff ist biobasiert und bioabbaubar. Für das Vorhaben kooperieren die RUB, das Fraunhofer-Institut für Grenzflächen- und Bioverfahrenstechnik IGB in Straubing und der Industriepartner AURO Pflanzenchemie AG. Die Deutsche Forschungsgemeinschaft fördert das Projekt von Oktober 2022 bis September 2025 mit 214.200 Euro.&lt;/p&gt;
&lt;p&gt;Ausgangspunkt für die Arbeiten ist die Substanz 5-Hydroxymethylfurfural (HMF), die sich aus Biomasse gewinnen und in Dimethylfuran (DMF) umwandeln lässt. Das Verfahren dafür haben Forschende der RUB um Prof. Dr. Martin Muhler und Dr. Baoxiang Peng vom Lehrstuhl für Technische Chemie bereits in einem &lt;a href=&quot;/wissenschaft/2021-02-08-chemie-neuer-syntheseweg-fuer-biosprit-produktion&quot;&gt;Vorgängerprojekt&lt;/a&gt; etabliert. Im aktuellen Forschungsvorhaben wollen sie den Katalysator und die Reaktionsbedingungen optimieren, um die Basis für eine industrielle Produktion von DMF zu legen.&lt;/p&gt;
&lt;p&gt;Das IGB-Team wird die katalytische Reaktion auf einen 40-fach größeren Maßstab hochskalieren. Zusammen mit dem Industriepartner AURO werden die Wissenschaftlerinnen und Wissenschaftler schließlich fertig ausgearbeitete Rezepte für den Einsatz von DMF als Lösungsmittel zur Verfügung stellen und in der Produktion von Naturfarben erproben.&lt;/p&gt;
&lt;p&gt;[infobox:1]&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Ein biobasiertes Lösungsmittel für Farben und Lacke</title>
 <link>https://news.rub.de/wissenschaft/2022-09-08-neues-projekt-ein-biobasiertes-loesungsmittel-fuer-farben-und-lacke</link>
 <description>
  
    Bislang ist nur ein kleiner Teil der etablierten Lösungsmittel biobasiert. Das möchte das Projektteam ändern – und denkt dabei die gesamte Prozesskette von Anfang bis Ende mit.
  
</description>
 <guid isPermaLink="false">rub-newportal-9246</guid>
 <pubDate>Thu, 08 Sep 2022 10:57:59 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;Nachhaltig, politisch und praxisorientiert – der Optionalbereich an der RUB bietet Studierenden im Wintersemester 2022/2023 die Möglichkeit, den Wissenshorizont zu erweitern. Sprachkurse zu wählen, die Erweiterung der Interessengebiete anzustreben, praktische Erfahrungen zu sammeln oder darüber hinaus fremde Fächer kennenzulernen, das alles ermöglicht der Optionalbereich. Studierende können sich ab sofort zu den Kursen anmelden. Alle Informationen sind auf den &lt;a href=&quot;https://optio.ruhr-uni-bochum.de/&quot;&gt;Seiten des Optionalbereichs&lt;/a&gt; zu finden.&lt;/p&gt;
&lt;p&gt;Insgesamt über 100 Kurse in den acht Profilen Praxis, Lehramt, Zukunft, Sprachen, International, Forschung, Freie Studien und Wissensvermittlung werden den Studierenden im Optionalbereich angeboten. „Zugleich bietet er unendlich viel Freiheit für Lehrende und Studierende und immer neue Chancen, sich auszuprobieren. Insbesondere das neue Profil Zukunft, die Entwicklung qualitativ hochwertiger Zertifikate und die Internationalisierung im Rahmen des Universitätsnetzwerks UNIC zeigen das exemplarisch“, betont Prof. Dr. Sebastian Susteck, Studiendekan des Optionalbereichs.&lt;/p&gt;
&lt;h4&gt;
	Auch wieder dabei: Nachhaltigkeit&lt;/h4&gt;
&lt;p&gt;Bereits zum fünften Mal wird das Modul &lt;a href=&quot;https://module.optio.ruhr-uni-bochum.de/modules/5558&quot;&gt;„Nachhaltigkeit und Zukunft – Interdisziplinäre Aspekte“&lt;/a&gt; angeboten, dessen Ringvorlesung auch für das breite Publikum geöffnet ist. Auch können Interessierte an der &lt;a href=&quot;https://module.optio.ruhr-uni-bochum.de/modules/5405&quot;&gt;Winter School „Nachhaltigkeitsdilemmata: Ressourcenschonung, Klimaschutz und Plastikvermeidung“&lt;/a&gt; des Germanistischen Instituts teilnehmen. Wer eine internationale Sicht auf das Thema erhalten will, kann am UNIC-Kurs &lt;a href=&quot;https://module.optio.ruhr-uni-bochum.de/modules/5362&quot;&gt;„Tourism, development and sustainability“&lt;/a&gt; teilnehmen und sich über die University of Oulu dafür anmelden.&lt;/p&gt;
&lt;h4&gt;
	Politisches Zeitgeschehen&lt;/h4&gt;
&lt;p&gt;Aktuelle politische Ereignisse und die wissenschaftliche Auseinandersetzung mit ihnen bilden die Modulangebote aus unterschiedlichen Perspektiven ebenfalls ab. Verschiedene Facetten thematisieren Veranstaltungen wie &lt;a href=&quot;https://module.optio.ruhr-uni-bochum.de/modules/5419&quot;&gt;„Menschenrechte und Demokratie in Krisenzeiten“&lt;/a&gt; der Fakultät für Geschichtswissenschaften oder &lt;a href=&quot;https://module.optio.ruhr-uni-bochum.de/modules/5311&quot;&gt;„Flüchtlingsgespräche. Diskurse über Zuwanderung in Deutschland 1952/2022“&lt;/a&gt; des Instituts für Deutschlandforschung.&lt;/p&gt;
&lt;h4&gt;
	Praktische Erfahrungen&lt;/h4&gt;
&lt;p&gt;„Praxisorientierte Modulangebote und Praktika sind integraler Bestandteil des Optionalbereichs. Sie berücksichtigen die Anforderungen unterschiedlicher Berufsfelder, sei es über einzelne Module oder auch über Zertifikate“, betont Astrid Steger, die Leiterin der Geschäftsstelle des Optionalbereichs. So bietet das Schreibzentrum den Kurs &lt;a href=&quot;https://module.optio.ruhr-uni-bochum.de/modules/5515&quot;&gt;„Den Fuß in die Tür – Schreiben und Veröffentlichen in Literaturbetrieb und Kulturjournalismus“&lt;/a&gt; an und das Institut für Erziehungswissenschaft in einer Kooperation mit der Universität Duisburg-Essen das &lt;a href=&quot;https://module.optio.ruhr-uni-bochum.de/modules/5535&quot;&gt;„Creative Lab Ruhr: Gesellschaftlich wirken und regional vernetzen“&lt;/a&gt;. Internationale Studierende höherer Semester können sich zur Veranstaltung &lt;a href=&quot;https://module.optio.ruhr-uni-bochum.de/modules/5521&quot;&gt;„uniWORKcity – Arbeitsmarktintegration für internationale Studierende“&lt;/a&gt; des International Office anmelden.&lt;/p&gt;
&lt;p&gt;[infobox:1]&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Das neue Modulangebot des Optionalbereichs ist online</title>
 <link>https://news.rub.de/studium/2022-09-08-studium-das-neue-modulangebot-des-optionalbereichs-ist-online</link>
 <description>
  
    Neues Profil, Zertifikate und Sprachen: Ein Blick ins neue Programm lohnt sich.
  
</description>
 <guid isPermaLink="false">rub-newportal-9262</guid>
 <pubDate>Thu, 08 Sep 2022 10:04:55 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;Die globalen Hotspots des Katastrophenrisikos durch Naturgefahren liegen in Amerika und Asien. Dies zeigt der WeltRisikoIndex 2022, den das Institut für Friedenssicherungsrecht und Humanitäres Völkerrecht (IFHV) der RUB und das „Bündnis Entwicklung Hilft“ am 8. September 2022 als Teil des WeltRisikoBerichts 2022 veröffentlicht haben.&lt;/p&gt;
&lt;h4&gt;
	Seit 2011 jährlich veröffentlicht&lt;/h4&gt;
&lt;p&gt;Der seit 2011 jährlich veröffentlichte Index wurde für die 2022er-Ausgabe konzeptionell und methodisch vollständig überarbeitet. Der WeltRisikoIndex berechnet das Katastrophenrisiko für 193 Länder und somit 99 Prozent der Weltbevölkerung, das höchste Risiko haben die Philippinen, Indien und Indonesien, gefolgt von Kolumbien und Mexiko. Deutschland liegt auf Rang 101 im globalen Mittelfeld – und damit nicht mehr wie in der Vergangenheit in der niedrigsten der fünf Risikoklassen.&lt;/p&gt;
&lt;p&gt;[zitat:1]&lt;/p&gt;
&lt;p&gt;„Überschwemmungen, Hitzewellen und Dürren nehmen gravierend zu, der Klimawandel hat auch auf die Risikoeinschätzung massive Auswirkungen. Für das Risiko eines Landes, dass aus einem extremen Naturereignis eine Katastrophe wird, bildet die natur- und klimabedingte Exposition den ersten Teil der Gleichung. Der zweite Teil ist die sogenannte Vulnerabilität der Gesellschaft. Diese Verwundbarkeit ist der direkt beeinflussbare Faktor des Risikos“, erklärt Dr. Katrin Radtke vom IFHV, wissenschaftliche Projektleiterin des WeltRisikoBericht 2022 mit dem Fokusthema „Digitalisierung“. „Durch die Verfügbarkeit neuer Daten zeichnet der neue WeltRisikoIndex ein präziseres und ausdifferenzierteres Risiko-Bild. Dabei liefert die Digitalisierung wichtige Grundlagen. Zudem erweitern digitale Daten und Systeme die Bandbreite des Möglichen für Behörden und Hilfsorganisationen sowohl im Management von Katastrophenrisiken als auch bei der Nothilfe nach Eintritt eines extremen Naturereignisses.“&lt;/p&gt;
&lt;p&gt;[zitat:2]&lt;/p&gt;
&lt;p&gt;„Insgesamt umfasst der WeltRisikoIndex nun 100 statt zuvor 27 Indikatoren. Insbesondere die Aufnahme von Indikatoren zur Betroffenheit von Bevölkerungen durch Katastrophen und Konflikte in den vergangenen fünf Jahren sowie zu Geflüchteten, Vertriebenen und Asylsuchenden in den neuen Index bewirkt – auch vor dem Hintergrund der großen globalen Migrationsbewegungen – eine deutlich genauere Abbildung der Lebensrealitäten in vielen Ländern“, erklärt Daniel Weller, Wissenschaftlicher Mitarbeiter am IFHV. „Zudem wurde die Komponente ‚Exposition‘ deutlich erweitert: Während im bisherigen WeltRisikoIndex Erdbeben, Wirbelstürme, Überschwemmungen, Dürren und Meeresspiegelanstieg berücksichtigt wurden, kommen nun Tsunamis hinzu und es wird zwischen Küsten- und Flussüberschwemmungen unterschieden.“&lt;/p&gt;
&lt;p&gt;[infobox:1]&lt;/p&gt;
&lt;p&gt;[infobox:2]&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Sehr hohes Katastrophenrisiko für Amerika und Asien</title>
 <link>https://news.rub.de/wissenschaft/2022-09-08-naturgefahren-sehr-hohes-katastrophenrisiko-fuer-amerika-und-asien</link>
 <description>
  
    Auch für Deutschland gilt laut dem aktuellen WeltRisikoIndex nun kein niedriges Risiko mehr.
  
</description>
 <guid isPermaLink="false">rub-newportal-9273</guid>
 <pubDate>Thu, 08 Sep 2022 10:48:28 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;„Kirchengeschichte bedeutet für mich Gesellschaftsgeschichte. Das ist mein Ansatz, um das Fach von seinem verstaubten Image zu befreien“, sagt Florian Bock. Er ist seit 18. Mai 2022 neu ernannter Professor für Kirchengeschichte des Mittelalters und der Neuzeit an der Katholisch-Theologischen Fakultät. In vier Forschungsschwerpunkten rückt er die Christinnen und Christen und das, was sie im Alltag bewegt hat, in den Fokus.&lt;/p&gt;
&lt;p&gt;[zitat:1]&lt;/p&gt;
&lt;p&gt;Dabei arbeitet Florian Bock mit seinem Team zum einen die kirchliche Zeitgeschichte der vergangenen 50 bis 60 Jahre auf. „In den 1970er- und 1980er-Jahren war die katholische Kirche noch vielerorts eine Volkskirche“, verdeutlicht er. Die Hälfte der Bundesbürgerinnen und -bürger war katholisch. „Wenn man auf die Kirchengeschichte schaut, schaut man wie durch ein Brennglas auch auf die Gesellschaftsgeschichte der Bundesrepublik“, meint Bock. „Die großen Debatten, etwa zu Umwelt oder Atomkraft, spiegeln sich hier im Kleinen wider.“ Beleuchtete Bock in der Vergangenheit etwa die Diskussion zum Umgang mit der Anti-Baby-Pille, so untersuchen die Wissenschaftlerinnen und Wissenschaftler an der Professur gegenwärtig, wie es zusammenpasst, &lt;a href=&quot;/wissenschaft/2021-09-06-theologie-katholisch-sein-und-gruen-waehlen&quot;&gt;katholisch zu sein und grün zu wählen&lt;/a&gt;.&lt;/p&gt;
&lt;h4&gt;
	Predigten aus der Frühen Neuzeit gaben Orientierung im Alltag&lt;/h4&gt;
&lt;p&gt;In einem anderen Forschungsschwerpunkt befasst sich Florian Bock mit der Gesellschaftsgeschichte der Frühen Neuzeit. Der Kirchenhistoriker analysiert die Inhalte von Predigten aus den Jahren 1670 bis 1800. „Das waren mehr als langweilige Reden am Sonntag“, weiß Bock. „Die Predigten haben den Lebensrhythmus der Menschen bestimmt.“ Wie sollten Familien zusammenleben? Wie sieht die ideale Kindererziehung aus? Wie sollte man sich um Alte und Kranke kümmern? Wie sollten Zinsen bemessen sein? Wie die Gesellschaft zu diesen Themen stand, lässt sich aus den damaligen Predigten herauslesen.&lt;/p&gt;
&lt;p&gt;[zitat:2]&lt;/p&gt;
&lt;p&gt;Einen weiteren Fokus legt Bocks Team auf die Lokalgeschichte. „Trends in der Bundesrepublik fanden sich im Ruhrgebiet in der Regel immer schon ein paar Jahre früher wieder“, schildert der Theologe. Säkularisierung, Interreligiosität und die Zusammenlegung von Gemeinden sind drei Beispiele für Entwicklungen, die sich im Ruhrgebiet früher als an anderen Orten abzeichneten.&lt;/p&gt;
&lt;h4&gt;
	Was wäre wenn: Kirchengeschichte anders unterrichten&lt;/h4&gt;
&lt;p&gt;Zuletzt beschäftigt sich die Arbeitsgruppe von Florian Bock auch mit der Didaktik der Kirchengeschichte – bislang eher ein Randthema für den Schulunterricht. Dabei arbeiten die Bochumer Forschenden mit der kontrafaktischen Methode. „Wir lassen Schülerinnen und Schüler überlegen, was wäre, wenn …“, erklärt Florian Bock. Was wäre, wenn das Zweite Vatikanische Konzil nie stattgefunden hätte, mit dem eine Öffnung der Kirche einherging? Was wäre, wenn die Kirche mehr Widerstand gegen Adolf Hitler geleistet hätte? „Mit diesen Übungen schlüpfen die Lernenden in die Perspektive der damaligen Akteurinnen und Akteure“, sagt Bock. „Sie befinden sich gedanklich in der Entscheidungssituation von damals – das macht Geschichte lebendig.“&lt;/p&gt;
&lt;p&gt;Bei der Ausbildung der Studierenden setzt Bocks Gruppe auf das Forschende Lernen. Studierende fahren mit in die Archive, arbeiten mit Originalmaterialien oder werden künftig selbst kleine museale Ausstellungen konzipieren.&lt;/p&gt;
&lt;p&gt;[infobox:1]&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Florian Bock nutzt die Kirchengeschichte als Brennglas</title>
 <link>https://news.rub.de/leute/2022-09-07-theologie-florian-bock-nutzt-die-kirchengeschichte-als-brennglas</link>
 <description>
  
    Der neu ernannte Professor an der Katholisch-Theologischen Fakultät stellt bei seinen kirchengeschichtlichen Forschungen die Gesellschaft in den Mittelpunkt.
  
</description>
 <guid isPermaLink="false">rub-newportal-9259</guid>
 <pubDate>Wed, 07 Sep 2022 09:31:28 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
 <item> <content>
  &lt;div class=&quot;field-std-text&quot;&gt;
    &lt;p&gt;Von der Grundlagenforschung bis zur Therapie – die Besucherinnen und Besucher des &lt;a href=&quot;https://www.sfb874.ruhr-uni-bochum.de/brain-day-page/&quot;&gt;Brain Day&lt;/a&gt; lernen das komplexeste menschliche Organ von einer ganz neuen Seite kennen: Am 14. September 2022 dreht sich alles um das Gehirn. Von der Macht der Neurotransmitter, über traumatische Gedächtnisspuren, bis tief hinein in die virtuelle Realität – die Gäste erwartet zwischen 13 und 17 Uhr ein buntes Programm aus Vorträgen und Mitmachaktionen rund um aktuelle Themen aus den Neurowissenschaften – live und in Präsenz im Veranstaltungszentrum der RUB.&lt;/p&gt;
&lt;p&gt;[infobox:1]&lt;/p&gt;
&lt;p&gt;Im ersten Vortrag des Tages beschäftigt sich Prof. Dr. Martin Tegenthoff von der Neurologischen Universitätsklinik und Poliklinik am BG-Universitätsklinikum Bergmannsheil, mit dem Thema „Post-Covid. Zwischen Wahn und Wirklichkeit“. Anschließend spricht Prof. Dr. Olivia Masseck aus dem Fachbereich „Biologie/Chemie“ der Universität Bremen über die Macht der Neurotransmitter und erläutert am Beispiel Serotonin, wie Hormone unser Gedächtnis formen.&lt;/p&gt;
&lt;p&gt;Am Nachmittag berichtet Prof. Dr. Nikolai Axmacher aus der Abteilung Neuropsychologie am Institut für Kognitive Neurowissenschaft der Fakultät für Psychologie der RUB über neue Erkenntnisse zu traumatischen Gedächtnisspuren im Gehirn. Er rückt insbesondere das Themengebiet der posttraumatischen Belastungsstörung in den Fokus. Den Abschluss des Programms bildet ein Vortrag von Prof. Dr. Denise Manahan-Vaughan, Sprecherin des SFB 874 sowie Leiterin der Abteilung für Neurophysiologie an der Medizinische Fakultät der Ruhr-Universität Bochum, zum Thema „Wieso Gerüche unsere Erinnerungen prägen“ und entführt alle Brain Day-Besucherinnen und -Besucher auf eine spannende Reise vom Riechkolben bis ins limbische System.&lt;/p&gt;
&lt;p&gt;[infobox:2]&lt;/p&gt;
&lt;p&gt;Zwischen den Vorträgen gibt es ein abwechslungsreiches Rahmenprogramm, bei dem alle Gäste eingeladen sind, mit den Neurowissenschaftlerinnen und Neurowissenschaftlern der RUB ins Gespräch zu kommen. Warum brennt Chili und warum ist Minze kalt? Wie beeinflussen Stresshormone unsere Erinnerungen? Und wieso sind wir in der Lage unbekannte Objekte in sinnvolle Gruppen einzuteilen? Dies sind nur drei der unzähligen Fragen rund um das komplexeste Organ des Menschen, die an den Informationsständen in diesem Jahr geklärt werden.&lt;/p&gt;
&lt;p&gt;Mikroskope, Exponate und Schaubilder stehen bereit zum Erkunden und Ausprobieren: Die Mitarbeiterinnen und Mitarbeiter des Instituts für Anatomie, Abteilung Cytologie, geben faszinierende Einblicke in Strukturen wie Hippocampus, Cerebellum oder Hirnanhangdrüse.&lt;br /&gt;
	Aktiv wird es in den Sälen 3 und 4 des Veranstaltungszentrums: ganz real im Mitmach-Parcours der Sportwissenschaft oder mit 3D-Video-Brille und Bewegungssensoren in der virtuellen Realität der Abteilung Neurotechnologie.&lt;/p&gt;
&lt;h4&gt;
	Selbsthilfegruppen bieten vielfältige Informationen&lt;/h4&gt;
&lt;p&gt;Im Saal 1 bieten Selbsthilfegruppen vielfältige Informationen. In diesem Jahr beim Brain Day vor Ort: Alzheimer Gesellschaft Bochum, Autismus-Therapie-Zentrum Dortmund/Hagen, Der Paritätische/ Selbsthilfe-Kontaktstelle Bochum, Gesichtsfeldausfall-Selbsthilfegruppe Niederrhein sowie die Selbsthilfegruppen „Leben mit Schädelhirntrauma“, „Epilepsie Essen“ und „Schlaganfall Ratingen“.&lt;/p&gt;
  &lt;/div&gt;
</content>
 <title>Das Gehirn besser verstehen</title>
 <link>https://news.rub.de/wissenschaft/2022-09-07-brain-day-das-gehirn-besser-verstehen</link>
 <description>
  
    Ein Nachmittag im Zeichen der Bochumer Neurowissenschaften mit Vorträgen, Informationen und Mitmachaktionen.
  
</description>
 <guid isPermaLink="false">rub-newportal-9229</guid>
 <pubDate>Wed, 07 Sep 2022 09:31:00 +0200</pubDate>
 <source url="https://news.rub.de/newsfeed">Newsportal - Ruhr-Universität Bochum</source>
</item>
</channel>
</rss>
''';
