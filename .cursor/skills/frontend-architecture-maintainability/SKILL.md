---
name: frontend-architecture-maintainability
description: Guides frontend modifications following Atomic Design, small specialized components, SRP, and maintainability. Use when refactoring UI, creating widgets/pages/features, reviewing frontend architecture, or when the user mentions Atomic Design, componentes monolíticos, mantenibilidad, pages, features, or arquitectura frontend.
disable-model-invocation: true
---

# Frontend Architecture & Maintainability Skill

## Objetivo

Este skill establece las reglas que deben seguirse al modificar, refactorizar o implementar cualquier funcionalidad dentro del frontend.

El objetivo principal es mantener una base de código:

* Fácil de entender.
* Fácil de modificar.
* Fácil de extender.
* Fácil de probar.
* Consistente con la arquitectura actual.
* Con componentes pequeños y especializados.
* Con responsabilidades claramente separadas.
* Sin duplicación innecesaria.
* Sin componentes monolíticos o difíciles de mantener.

La prioridad no es únicamente que el código "funcione", sino que **la próxima modificación sea sencilla y segura de realizar**.

---

## 1. Regla principal: respetar la arquitectura existente

Antes de modificar o crear código:

1. Analizar la estructura actual del proyecto.
2. Identificar cómo está organizada la arquitectura.
3. Identificar patrones existentes.
4. Reutilizar componentes, hooks, servicios, utilidades y patrones existentes cuando sea apropiado.
5. No introducir una arquitectura paralela.
6. No crear nuevas abstracciones si ya existe una solución equivalente.
7. Mantener consistencia con las convenciones actuales.

La solución propuesta debe **integrarse en la arquitectura existente**, no obligar a la arquitectura existente a adaptarse innecesariamente a la nueva funcionalidad.

---

# 2. Atomic Design

El proyecto utiliza Atomic Design.

La implementación debe respetar la responsabilidad de cada nivel:

### Atoms

Elementos UI básicos y reutilizables.

Ejemplos:

* Button
* Input
* Label
* Icon
* Badge
* Divider
* Typography

Un Atom:

* No debe contener lógica de negocio.
* Debe ser altamente reutilizable.
* Debe tener una API simple.
* No debe conocer el contexto específico de una pantalla.

---

### Molecules

Combinaciones pequeñas de Atoms que representan una funcionalidad visual concreta.

Ejemplos:

* SearchField
* FormField
* PriceDisplay
* ProductQuantitySelector
* TaxIndicator

Una Molecule puede manejar interacción visual simple, pero no debe convertirse en un contenedor de lógica de negocio.

---

### Organisms

Componentes funcionales más completos construidos utilizando Atoms y Molecules.

Ejemplos:

* ProductCard
* CheckoutSummary
* PaymentMethods
* ProductList
* CustomerSelector

Un Organism puede coordinar varios componentes, pero debe evitar convertirse en un componente monolítico.

---

### Templates

Definen la estructura y distribución general de una página.

Deben encargarse principalmente de:

* Layout.
* Distribución.
* Slots/children.
* Estructura visual.

No deben contener lógica compleja de negocio.

---

### Pages

Representan una pantalla concreta de la aplicación.

Son responsables de:

* Coordinar los componentes.
* Conectar estado y datos.
* Ejecutar acciones.
* Coordinar servicios o casos de uso.
* Componer Templates y Organisms.

La Page debe actuar como **orquestador**, no como contenedor de toda la lógica de la aplicación.

---

# 3. Regla de componentes pequeños

Evitar componentes excesivamente grandes.

Si un componente comienza a tener:

* Mucho JSX/UI.
* Muchos estados.
* Muchos handlers.
* Múltiples responsabilidades.
* Condicionales complejos.
* Lógica de negocio.
* Cálculos.
* Peticiones HTTP.
* Transformación de datos.

Debe evaluarse su división.

### Regla práctica

Si un componente necesita demasiado contexto para poder entenderse, probablemente necesita ser dividido.

La intención es poder abrir un archivo y entender rápidamente:

> Qué representa, qué recibe, qué devuelve y cuál es su responsabilidad.

---

# 4. Single Responsibility Principle

Cada componente, hook, servicio o función debe tener una responsabilidad clara.

Evitar componentes que hagan simultáneamente:

```text
UI
+ estado
+ validaciones
+ cálculos
+ llamadas HTTP
+ transformación de datos
+ navegación
+ lógica de negocio
```

Separar responsabilidades cuando sea necesario:

```text
Component
    ↓
Hook / Controller
    ↓
Use Case / Business Logic
    ↓
Service / API
```

La separación concreta debe respetar la arquitectura existente del proyecto.

No crear capas artificiales únicamente por cumplir una regla.

---

# 5. Separar UI de lógica de negocio

La UI debe enfocarse en representar el estado.

Evitar:

```text
Componente
    ├── calcular impuestos
    ├── transformar respuesta API
    ├── validar reglas comerciales
    ├── realizar peticiones
    └── renderizar interfaz
```

Preferir:

```text
Componente
    ↓
Hook / Controller
    ↓
Lógica de negocio
    ↓
Service
```

Esto permite modificar la interfaz sin modificar la lógica de negocio y viceversa.

---

# 6. Evitar componentes "God Component"

Un componente que contiene demasiada responsabilidad debe ser considerado una señal de alerta.

Antes de agregar código a un componente grande, evaluar:

* ¿Esta lógica pertenece realmente aquí?
* ¿Puede convertirse en un componente independiente?
* ¿Puede convertirse en un hook?
* ¿Es lógica de negocio?
* ¿Debe pertenecer a un servicio?
* ¿Existe un componente reutilizable que ya resuelva esto?

No continuar aumentando el tamaño de un componente simplemente porque "ya funciona ahí".

---

# 7. Reutilización inteligente

Reutilizar código cuando existe una responsabilidad compartida.

Sin embargo, evitar abstraer prematuramente.

No crear:

```text
UniversalComponent
GenericComponent
BaseComponent
MegaComponent
```

únicamente para evitar unas pocas líneas de código.

La abstracción debe existir cuando existe una **responsabilidad realmente compartida**.

La reutilización debe reducir complejidad, no aumentarla.

---

# 8. Evitar duplicación

Antes de crear una nueva implementación:

1. Buscar si ya existe una solución.
2. Identificar componentes similares.
3. Revisar hooks existentes.
4. Revisar servicios.
5. Revisar utilidades.
6. Revisar constantes y configuraciones.

Si existe una solución reutilizable, extenderla de forma compatible cuando sea razonable.

Evitar crear dos implementaciones diferentes para resolver el mismo problema.

---

# 9. Props y APIs simples

Los componentes deben tener interfaces claras y predecibles.

Evitar componentes con cantidades excesivas de props:

```text
prop1
prop2
prop3
prop4
prop5
prop6
prop7
prop8
prop9
...
```

Si un componente requiere demasiadas configuraciones, evaluar si:

* Está haciendo demasiado.
* Debe dividirse.
* Algunas props pertenecen a un objeto de configuración.
* Existe una responsabilidad que debería delegarse.

La API de un componente debe comunicar claramente cómo utilizarlo.

---

# 10. Evitar lógica condicional excesiva

Evitar estructuras como:

```text
if A
    if B
        if C
            if D
                ...
```

Cuando la lógica sea compleja, extraerla a funciones, hooks, casos de uso o estrategias según corresponda.

La UI debe permanecer legible.

Preferir:

```text
const canContinue = canUserContinue(state);
```

en lugar de colocar toda la lógica dentro del render.

---

# 11. Nombres claros

Los nombres deben explicar la intención.

Evitar:

```text
data
item
obj
temp
value
handleData
processData
doSomething
```

Preferir nombres que representen el dominio:

```text
checkoutSummary
selectedPaymentMethod
calculateTax
calculateSubtotal
handlePaymentMethodChange
```

Un buen nombre reduce la necesidad de comentarios.

---

# 12. Funciones pequeñas

Las funciones deben realizar una tarea específica.

Evitar funciones que:

* Transformen datos.
* Calculen valores.
* Actualicen estado.
* Realicen peticiones.
* Naveguen.
* Y además procesen la UI.

Cuando una función empieza a tener demasiadas responsabilidades, dividirla.

---

# 13. No modificar comportamiento innecesariamente

Durante un refactor:

* No cambiar reglas de negocio sin justificación.
* No modificar contratos de API sin necesidad.
* No cambiar comportamiento visual accidentalmente.
* No introducir dependencias innecesarias.
* No modificar archivos que no estén relacionados con el objetivo.

El refactor debe mejorar la estructura **sin alterar el comportamiento existente**, salvo que el cambio funcional sea explícitamente solicitado.

---

# 14. Antes de crear algo nuevo

Siempre realizar este análisis:

```text
¿Ya existe?

    ↓ Sí
¿Puedo reutilizarlo?

    ↓ Sí
Reutilizar.

    ↓ No
¿Puedo extender una solución existente?

    ↓ Sí
Extender.

    ↓ No
Crear nueva implementación.
```

No crear componentes, hooks, servicios o utilidades duplicadas sin revisar primero el código existente.

---

# 15. Cambios fáciles de localizar

La estructura debe permitir responder rápidamente:

* ¿Dónde está la UI?
* ¿Dónde está la lógica?
* ¿Dónde se obtiene la información?
* ¿Dónde se transforma?
* ¿Dónde se calcula?
* ¿Dónde se configura?
* ¿Dónde se modifica el comportamiento?

Evitar distribuir una responsabilidad en demasiados archivos sin necesidad.

La arquitectura debe favorecer la **localización rápida del cambio**.

---

# 16. Mantenibilidad como criterio de aceptación

Una implementación no debe considerarse terminada únicamente porque funciona.

También debe evaluarse:

### Legibilidad

¿Otro desarrollador puede entenderlo rápidamente?

### Modificabilidad

¿Es sencillo cambiarlo?

### Extensibilidad

¿Es sencillo agregar otro caso?

### Reutilización

¿La solución puede reutilizarse correctamente?

### Aislamiento

¿Un cambio pequeño puede realizarse sin afectar múltiples partes del sistema?

### Consistencia

¿Respeta los patrones actuales del proyecto?

---

# 17. Refactor incremental

No realizar refactors masivos innecesarios.

Preferir:

```text
Analizar
    ↓
Identificar problema
    ↓
Extraer responsabilidad
    ↓
Validar comportamiento
    ↓
Continuar
```

Cada cambio debe tener un propósito claro.

Evitar reestructurar todo el proyecto únicamente porque una parte necesita ser modificada.

---

# 18. Regla de modificación

Cuando se solicite una modificación:

1. Analizar primero el código existente.
2. Identificar la responsabilidad actual.
3. Detectar acoplamientos.
4. Determinar dónde debería vivir el nuevo comportamiento.
5. Reutilizar lo existente cuando sea posible.
6. Implementar el cambio.
7. Si el cambio aumenta significativamente la complejidad, refactorizar antes de continuar.
8. Mantener Atomic Design.
9. Evitar componentes monolíticos.
10. Verificar que el resultado sea más fácil de mantener que la implementación anterior.

---

# 19. Regla de "cambio futuro"

Antes de finalizar una implementación, realizar esta pregunta:

> "Si mañana tengo que modificar esta funcionalidad, ¿qué tan difícil será encontrar y cambiar el código?"

Si la respuesta implica modificar múltiples componentes sin necesidad, navegar por lógica mezclada o entender un componente excesivamente grande, la implementación debe reconsiderarse.

La arquitectura debe estar diseñada pensando no solamente en el código actual, sino en **el costo de los cambios futuros**.

---

# 20. Principio final

Priorizar siempre:

```text
Claridad
    >
Simplicidad
    >
Mantenibilidad
    >
Reutilización
    >
Extensibilidad
    >
Abstracción
```

No sobre-ingenierizar.

No crear abstracciones innecesarias.

No aumentar la complejidad para cumplir patrones.

El mejor código es aquel que permite que otro desarrollador pueda:

```text
ENTENDER
    ↓
LOCALIZAR
    ↓
MODIFICAR
    ↓
EXTENDER
```

sin tener que comprender todo el sistema.

Cada nueva implementación debe dejar la arquitectura **igual o más mantenible que antes**.

## Criterio obligatorio

Antes de entregar cualquier cambio, comprobar:

* ¿Respeta la arquitectura actual?
* ¿Respeta Atomic Design?
* ¿El componente tiene una responsabilidad clara?
* ¿La lógica de negocio está separada de la UI?
* ¿Se reutilizó código existente cuando correspondía?
* ¿Se evitó duplicación?
* ¿Se evitaron componentes extensos?
* ¿Se evitaron abstracciones innecesarias?
* ¿Los nombres son claros?
* ¿El cambio futuro será sencillo?
* ¿La implementación es fácil de entender para otro desarrollador?

Si alguna respuesta es "no", revisar la implementación antes de considerarla terminada.

---

## Recursos de este repositorio

Convenciones Flutter/Dart y mapa de carpetas de este proyecto: [reference-proyecto-flutter.md](reference-proyecto-flutter.md)
