# Azukar FPGA — modelo para web

Modelo de presentación generado a partir del proyecto KiCad suministrado. Se mantienen los cuatro conectores laterales, el USB, los pulsadores y los componentes del proyecto. No se modificó el ZIP original.

## Qué archivo usar

- **azukar-web.glb**: 2.178.696 bytes (2,18 MB). Primera opción para reemplazar el modelo en un visor moderno. Texturas incluidas, sin decodificador de geometría adicional. El visor debe soportar KHR_mesh_quantization y EXT_texture_webp.
- **azukar-web-meshopt.glb**: 1.314.468 bytes (1,31 MB). Misma geometría y materiales, comprimidos con Meshopt. Requiere soporte de EXT_meshopt_compression; el decodificador clásico y su licencia están en vendor/.
- **azukar-poster.webp**: 91.058 bytes (91 KB), fondo transparente. Imagen inicial recomendada para la página.
- **azukar-front.webp / azukar-back.webp**: vistas de frente y dorso, de unos 110 y 95 KB.
- **azukar-hero.png / azukar-front.png / azukar-back.png**: renders PNG transparentes de mayor calidad.
- **azukar-editable.blend**: escena editable de Blender 5.0.1 con texturas empaquetadas, cámara e iluminación. No necesitás Blender para mostrar los GLB en la web.

Las dimensiones del PCB se mantienen en 100 × 75 × 1,6 mm. glTF utiliza metros. La cara de componentes apunta hacia +Y en el GLB. La escena Blender conserva la cara de componentes hacia +Z.

## Qué se optimizó

La exportación completa de referencia del mismo proyecto, con pistas, pads, zonas, máscara y serigrafía como geometría, medía 23.832.564 bytes. Contenía 463.670 triángulos y 29.004 primitivas. No es una medición del antiguo archivo del sitio.

Los dos GLB finales tienen 59.827 triángulos y 20 primitivas: aproximadamente 87 % menos triángulos y 99,93 % menos primitivas. Las primitivas son lotes de geometría/material, no una medición literal de todas las llamadas de dibujo del navegador: sombras y otras pasadas pueden sumar llamadas.

- Las 200 vías pequeñas se representan mediante textura/relieve superficial, sin cilindros ni perforaciones internas.
- Se conservan las 85 perforaciones de las huellas; se simplifica su contorno.
- Pistas, máscara, pads, logos y serigrafía se obtienen de las capas reales del PCB, no de una imagen inventada.
- Se simplifican los componentes y se agrupa la geometría por material.
- Se añaden materiales de plástico, cerámica y metal. El color, la rugosidad y el relieve son una aproximación visual basada en las referencias; no una medición física.
- El color de cada cara se guarda a 2048 × 1536; los mapas de relieve y propiedades del material, a 1024 × 768. Se comprimen en WebP.

No es un modelo para fabricación, análisis mecánico preciso o inspección de vías internas. No se inventaron marcas láser ni textos de los chips ausentes en los modelos fuente. La apariencia final también depende de la iluminación y exposición del visor.

## Cómo evitar que frene la página

La compresión del archivo por sí sola no elimina el coste de cargar el motor 3D, preparar materiales y subir datos a la GPU.

1. Mostrar azukar-poster.webp como imagen normal al abrir la página.
2. Cargar el código del visor y asignar el GLB solamente al pulsar «Explorar en 3D».
3. Mantener la imagen mientras se prepara el modelo; conservarla también si WebGL o la carga fallan.
4. No precargar el GLB ni importar el motor 3D desde el módulo inicial.
5. Evitar el giro automático permanente. En visores propios, renderizar cuando cambia la vista; limitar la resolución en pantallas de alta densidad.

El botón de activación protege la carga inicial. Al activar el 3D todavía puede haber trabajo en el hilo principal: no es una garantía de cero pausas en todos los dispositivos. La descarga asíncrona, un setTimeout o requestIdleCallback por sí solos no llevan todo el render a un worker.

Para model-viewer 4.3.1, cargar la biblioteca con import() dentro del manejador del botón y crear el elemento después. Si se usa la variante Meshopt, antes de crear el elemento:

```js
customElements.get('model-viewer').meshoptDecoderLocation =
  '/ruta-a-los-assets/vendor/meshopt_decoder.js';
```

Esa propiedad requiere el script clásico incluido, no meshopt_decoder.module.js. Para un visor Three.js propio, configurar GLTFLoader.setMeshoptDecoder() con el módulo MeshoptDecoder correspondiente. Con azukar-web.glb no hace falta esta configuración.

Referencias oficiales: [carga en model-viewer](https://modelviewer.dev/examples/loading/), [API de model-viewer](https://modelviewer.dev/docs/index.html), [gltfpack](https://github.com/zeux/meshoptimizer/blob/v1.2/gltf/README.md).

## Verificación y alcance

Los GLB cargaron sin errores JavaScript en Edge/Chromium con model-viewer 4.3.1. Se revisaron las vistas de frente, dorso y perspectiva. La prueba local comprobó que no se solicita el GLB ni la biblioteca del visor antes de pulsar el botón.

El validador glTF no encontró errores ni advertencias. Para Meshopt, el validador declara que no inspecciona internamente la extensión comprimida; su carga se comprobó además en el navegador. Las pruebas funcionales con CPU limitada a 4× no sustituyen una medición en teléfonos reales y con la red del sitio.

La integración en la página existente queda pendiente: no se encontró el código del sitio en la carpeta de trabajo original durante esta tarea. Este paquete no cambia ningún despliegue.

Se usaron KiCad 10.0, Blender 5.0.1 y gltfpack 1.2. No se utilizó IA generativa para reconstruir componentes, logos o circuitos. Los derechos y licencias del diseño y de los modelos fuente se mantienen; el procesamiento no los cambia.

