'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "288d42368e8d004a6f171211df838fea",
"assets/AssetManifest.bin.json": "298e7aaacdae64889e920c181907787b",
"assets/assets/backgrounds/background.jpg": "e9acbd561877ced485e759b5bf4c5a9b",
"assets/assets/fonts/%25E5%2585%25B6%25E4%25BB%2596%25E5%25AD%2597%25E4%25BD%2593/%25E6%25BC%2594%25E7%25A4%25BA%25E4%25BD%259B%25E7%25B3%25BB%25E4%25BD%2593.ttf": "14b2e49201b7f7ec8ea8749605680bee",
"assets/assets/fonts/%25E5%2585%25B6%25E4%25BB%2596%25E5%25AD%2597%25E4%25BD%2593/%25E6%25BC%2594%25E7%25A4%25BA%25E5%25A4%258F%25E8%25A1%258C%25E6%25A5%25B7.ttf": "2268941c82d850b3cbecdb96d8737ad4",
"assets/assets/fonts/%25E5%2585%25B6%25E4%25BB%2596%25E5%25AD%2597%25E4%25BD%2593/%25E6%25BC%2594%25E7%25A4%25BA%25E6%2582%25A0%25E7%2584%25B6%25E5%25B0%258F%25E6%25A5%25B7.ttf": "2f678c30a442bf1f96ac8e3a9a633cfe",
"assets/assets/fonts/%25E5%25BA%259E%25E9%2597%25A8%25E6%25AD%25A3%25E9%2581%2593%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E5%25BA%259E%25E9%2597%25A8%25E6%25AD%25A3%25E9%2581%2593%25E6%25A0%2587%25E9%25A2%2598%25E4%25BD%2593.ttf": "22482026911939769f163a00a35a1073",
"assets/assets/fonts/%25E5%25BA%259E%25E9%2597%25A8%25E6%25AD%25A3%25E9%2581%2593%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E5%25BA%259E%25E9%2597%25A8%25E6%25AD%25A3%25E9%2581%2593%25E7%25B2%2597%25E4%25B9%25A6%25E4%25BD%2593.ttf": "e453aa97485eee98587dd74d5cf11dbc",
"assets/assets/fonts/%25E6%2580%259D%25E6%25BA%2590%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%2580%259D%25E6%25BA%2590%25E5%25AE%258B%25E4%25BD%2593/SourceHanSerifCN-Regular.ttf": "c2fd3d73b0092680907f11ac6415347c",
"assets/assets/fonts/%25E6%2580%259D%25E6%25BA%2590%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%2580%259D%25E6%25BA%2590%25E6%259F%2594%25E9%25BB%2591/GenJyuuGothicL-Regular.ttf": "6bbb4fcb0eb0307b22cfca2d9d77f20a",
"assets/assets/fonts/%25E6%2580%259D%25E6%25BA%2590%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%2580%259D%25E6%25BA%2590%25E7%259C%259F%25E9%25BB%2591/GenShinGothic-Regular.ttf": "da0c7b8fe9af45e70b0f53668e7d760a",
"assets/assets/fonts/%25E6%2580%259D%25E6%25BA%2590%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%2580%259D%25E6%25BA%2590%25E9%25BB%2591%25E4%25BD%2593/SourceHanSansCN-Regular.otf": "11c302dd8c50619e4131da5d645fb422",
"assets/assets/fonts/%25E6%2596%25B9%25E6%25AD%25A3%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%2596%25B9%25E6%25AD%25A3%25E4%25B9%25A6%25E5%25AE%258B%25E7%25AE%2580%25E4%25BD%2593.ttf": "eb05abbf3ebe0be545cf022feda1778b",
"assets/assets/fonts/%25E6%2596%25B9%25E6%25AD%25A3%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%2596%25B9%25E6%25AD%25A3%25E4%25BB%25BF%25E5%25AE%258B%25E7%25AE%2580%25E4%25BD%2593.ttf": "3f9acae77d19596e962b856be1b85173",
"assets/assets/fonts/%25E6%2596%25B9%25E6%25AD%25A3%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%2596%25B9%25E6%25AD%25A3%25E6%25A5%25B7%25E4%25BD%2593%25E7%25AE%2580%25E4%25BD%2593.ttf": "439f3503db71d84f6ed37645cca025da",
"assets/assets/fonts/%25E6%2596%25B9%25E6%25AD%25A3%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%2596%25B9%25E6%25AD%25A3%25E9%25BB%2591%25E4%25BD%2593%25E7%25AE%2580%25E4%25BD%2593.ttf": "b6eaac673e04d1ec0a0c1bb93e516945",
"assets/assets/fonts/%25E6%25B2%2590%25E7%2591%25B6%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%25B2%2590%25E7%2591%25B6%25E8%25BD%25AF%25E7%25AC%2594%25E6%2589%258B%25E5%2586%2599%25E4%25BD%2593.ttf": "009ea542d4b984201b30a6cf2db555f8",
"assets/assets/fonts/%25E6%25B2%2590%25E7%2591%25B6%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E6%25B2%2590%25E7%2591%25B6%25E9%259A%258F%25E5%25BF%2583%25E6%2589%258B%25E5%2586%2599%25E4%25BD%2593.ttf": "7a2c44375518c09575e106717ad1e5e9",
"assets/assets/fonts/%25E7%258E%258B%25E6%25B1%2589%25E5%25AE%2597%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E7%258E%258B%25E6%25BC%25A2%25E5%25AE%2597%25E4%25B8%25AD%25E6%25A5%25B7%25E9%25AB%2594%25E6%25B3%25A8%25E9%259F%25B3.ttf": "205de7e2d986e4d6b2d2a09dd6acfda1",
"assets/assets/fonts/%25E7%258E%258B%25E6%25B1%2589%25E5%25AE%2597%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E7%258E%258B%25E6%25BC%25A2%25E5%25AE%2597%25E4%25B8%25AD%25E8%25A1%258C%25E6%259B%25B8%25E7%25B9%2581.ttf": "16372c5c0f213b616a38c29440a55392",
"assets/assets/fonts/%25E7%258E%258B%25E6%25B1%2589%25E5%25AE%2597%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E7%258E%258B%25E6%25BC%25A2%25E5%25AE%2597%25E4%25B8%25AD%25E9%259A%25B8%25E6%259B%25B8%25E7%25B9%2581.ttf": "9be6d68c52e4f5b2c4a71d17858d690c",
"assets/assets/fonts/%25E7%25AB%2599%25E9%2585%25B7%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%2520%25E7%25AB%2599%25E9%2585%25B7%25E9%25AB%2598%25E7%25AB%25AF%25E9%25BB%2591.ttf": "b201c25ecfc5ee6f159223ef2746f78d",
"assets/assets/fonts/%25E7%25AB%2599%25E9%2585%25B7%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E7%25AB%2599%25E9%2585%25B7%25E5%25BF%25AB%25E4%25B9%2590%25E4%25BD%2593.ttf": "0aceab97af2cd21dc57f76aceb1b1722",
"assets/assets/fonts/%25E7%25AB%2599%25E9%2585%25B7%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E7%25AB%2599%25E9%2585%25B7%25E6%2596%2587%25E8%2589%25BA%25E4%25BD%2593.ttf": "e7cbdb104483959fceaa167cfa9cb77e",
"assets/assets/fonts/%25E7%25AB%2599%25E9%2585%25B7%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E7%25AB%2599%25E9%2585%25B7%25E9%2585%25B7%25E9%25BB%2591%25E4%25BD%2593.ttf": "6b4f114c44c815accc37538e06e79d6b",
"assets/assets/fonts/%25E8%2583%25A1%25E6%2599%2593%25E6%25B3%25A2%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E8%2583%25A1%25E6%2599%2593%25E6%25B3%25A2%25E7%2594%25B7%25E7%25A5%259E%25E4%25BD%2593.otf": "1c6242d64be9081376927a789bd7f0c2",
"assets/assets/fonts/%25E8%2583%25A1%25E6%2599%2593%25E6%25B3%25A2%25E5%25AD%2597%25E4%25BD%2593%25E7%25B3%25BB%25E5%2588%2597/%25E8%2583%25A1%25E6%2599%2593%25E6%25B3%25A2%25E7%259C%259F%25E5%25B8%2585%25E4%25BD%2593.otf": "d79fb4684bc970942d727d863223fdb0",
"assets/assets/fonts/%25E9%2598%25BF%25E9%2587%258C%25E5%25B7%25B4%25E5%25B7%25B4%25E6%2599%25AE%25E6%2583%25A0%25E4%25BD%2593/Alibaba-PuHuiTi-Regular.ttf": "8d591595ec48e06178ace5eddfcee21c",
"assets/assets/fonts/academicons.eot": "f3f583a57dc7ccfb5c5bafb12ee05f4f",
"assets/assets/fonts/academicons.svg": "81fc47686d8af586351363f90b559aea",
"assets/assets/fonts/academicons.ttf": "a634eaa35b31b49f750ed34c367ea4de",
"assets/assets/fonts/academicons.woff": "4421b0e8a7b66deedf91143791fd0114",
"assets/assets/fonts/long-cang-6500.woff": "dad34901f1b15f2f9c24bdf8c48ad1b4",
"assets/assets/fonts/ma-shan-zheng-6500.woff": "16cdd2714bc0308c641a0006a7525004",
"assets/assets/fonts/qingcha_kaiti.ttf": "ba1dd81962e8ef20c99ea9ca2dfa1a58",
"assets/assets/fonts/xing_kaiti.TTF": "24dc4770a0c0f1b2a70d34a3a3ca616a",
"assets/assets/fonts/zhi-mang-xing-6500.woff": "f8c81256b701a6f2a097f0156fbb5017",
"assets/assets/templates/1.jpg": "dc6e05db04983e14452aee545cc49094",
"assets/assets/templates/pexels-1108936515-20895480.jpg": "b678d207dc874bf8a341eac5aa796178",
"assets/assets/templates/pexels-bertellifotografia-573299.jpg": "f55fa8c5f85acbba78795466ed4b02d5",
"assets/assets/templates/pexels-carocastilla-1716861.jpg": "19aaa523ed18a089fb9d01fb888d67ad",
"assets/assets/templates/pexels-cheng-shi-song-427082720-34903203.jpg": "22f2dcadfa7de7d3cce0ca5404594198",
"assets/assets/templates/pexels-dmitri-sotnikov-2712820-32219500.jpg": "cbea92063fc4a3b68bfce516bb7a3a9e",
"assets/assets/templates/pexels-elizabeth-ferreira-1040803688-29649276.jpg": "7d515d908e9a38b18be5f5396060a1ed",
"assets/assets/templates/pexels-h-i-nguy-n-1627264-3616937.jpg": "24922d887d75857d0d96388fc31fad08",
"assets/assets/templates/pexels-jess-vide-4321835.jpg": "aa894c00ba1836627f6af526dbbf3789",
"assets/assets/templates/pexels-lis-k-1975161963-30884074.jpg": "f3e1df18ef4c6cbe94a3340d5e1179cc",
"assets/assets/templates/pexels-ozge-taskiran-85164141-12596936.jpg": "870e21bded6af606c01b2586fcebd2eb",
"assets/assets/templates/pexels-paul-robinson-1446229-2796781.jpg": "f266a5bb555f0ce5e7632f1cd4687689",
"assets/assets/templates/pexels-sam-lim-655865-1586206.jpg": "88bcd706167ca87779ef385b16301ef8",
"assets/assets/templates/pexels-soldiervip-1382730.jpg": "db6d98b8f2990390bb7b01acd77aa56e",
"assets/assets/templates/pexels-thai-hu-nh-2335830-3998365.jpg": "a52b03767575ad3ca58767f77cd15358",
"assets/assets/templates/pexels-the-traveling-photo-experiment-41034029-8399147.jpg": "b25e50dc152f464b9a44850f63e0a8a9",
"assets/assets/templates/pexels-thek1d-773594.jpg": "823e1aa15994f520eb3d797ab27c819c",
"assets/assets/templates/pexels-tomer-dahari-571687-1331386.jpg": "d03b014a4c72e7260757c0e9e8a7e7d9",
"assets/assets/templates/pexels-valeriya-19287463.jpg": "5c9274d1d104f8158c1e9f3d11a5abb7",
"assets/assets/templates/pexels-zhangkaiyv-16144420.jpg": "e9acbd561877ced485e759b5bf4c5a9b",
"assets/assets/templates/pexels-zhangkaiyv-3210189.jpg": "d4538c15465e7c4c460b16d698d2d2a2",
"assets/FontManifest.json": "1120d66c72a11372f0330a4f0d983432",
"assets/fonts/MaterialIcons-Regular.otf": "b74d103b8de6e9c770d30fb291f233df",
"assets/NOTICES": "afb14688332f000055dc5e89c13a2d5c",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/shaders/stretch_effect.frag": "40d68efbbf360632f614c731219e95f0",
"canvaskit/canvaskit.js": "8331fe38e66b3a898c4f37648aaf7ee2",
"canvaskit/canvaskit.js.symbols": "a3c9f77715b642d0437d9c275caba91e",
"canvaskit/canvaskit.wasm": "9b6a7830bf26959b200594729d73538e",
"canvaskit/chromium/canvaskit.js": "a80c765aaa8af8645c9fb1aae53f9abf",
"canvaskit/chromium/canvaskit.js.symbols": "e2d09f0e434bc118bf67dae526737d07",
"canvaskit/chromium/canvaskit.wasm": "a726e3f75a84fcdf495a15817c63a35d",
"canvaskit/skwasm.js": "8060d46e9a4901ca9991edd3a26be4f0",
"canvaskit/skwasm.js.symbols": "3a4aadf4e8141f284bd524976b1d6bdc",
"canvaskit/skwasm.wasm": "7e5f3afdd3b0747a1fd4517cea239898",
"canvaskit/skwasm_heavy.js": "740d43a6b8240ef9e23eed8c48840da4",
"canvaskit/skwasm_heavy.js.symbols": "0755b4fb399918388d71b59ad390b055",
"canvaskit/skwasm_heavy.wasm": "b0be7910760d205ea4e011458df6ee01",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "24bc71911b75b5f8135c949e27a2984e",
"flutter_bootstrap.js": "c6f53bb801cc6e45623282060ac765c7",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "63756ed598081915247eaf938e3b7cc1",
"/": "63756ed598081915247eaf938e3b7cc1",
"main.dart.js": "925c03ccd55f572b386c52141088b20e",
"manifest.json": "7428f3e970bc27ce92c68a33b5aaa27c",
"version.json": "9866adfa6e7bd32fd681b6c1dc17e897"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
