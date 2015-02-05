<!DOCTYPE html>
<html class="no-js svg">
<head>
  {{> _header}}
</head>
<body>
  <div id="wrapper">
    <a href="javascript:void(0)" class="nav-mobile us-desktop--hidden js-toggle__link" data-target="sidebar"><span class="nav-mobile__hamburger">Open menu</span></a>
    {{> sidebar}}
    <div class="us-hero trailered">
      <div class="container sidebar--push styleguide__header">
        <h1 class="styleguide__title">{{page.name}}</h1>
        <div class='us-grid-row'>
          <nav class="styleguide__nav us-col-md-8">
            {{#page}}
              {{#blocks}}
                <div class="us-col-md-4">
                  <a class="styleguide__nav-link" href="/docs/{{../page}}#{{link}}">{{name}}</a>
                </div>
              {{/blocks}}
            {{/page}}
          </nav>
        </div>
      </div>
    </div>
    <div class="styleguide container sidebar--push">
      {{#page}}
        {{#blocks}}
          {{#if partial}}
            {{partial partial}}
          {{else}}
            {{> style_block}}
          {{/if}}
        {{/blocks}}
      {{/page}}
    </div>
  </div>
  <script src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js"></script>
  <script src="js/app.js"></script>
</body>
</html>
