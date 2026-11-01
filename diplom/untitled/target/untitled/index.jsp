<%@ page pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html lang="ru">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>GreenShop — Магазин экотоваров</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css">
  <link rel="stylesheet" href="style/style.css">
</head>
<body>

  <!-- Шапка -->
  <jsp:include page="/compоnents/cap.jsp" />

  <!-- Баннер -->
  <jsp:include page="/compоnents/banner.jsp" />

  <!-- Секция каталога: фильтры + сетка товаров -->
  <jsp:include page="/compоnents/catalog.jsp" />

  <!-- Модальное окно: карточка товара -->
  <jsp:include page="/compоnents/card.jsp" />

  <!-- Подвал -->
  <jsp:include page="/compоnents/basement.jsp" />

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script>
      window.APP_CONTEXT = "\${pageContext.request.contextPath}";
  </script>
  <script src="script/script.js"></script>
</body>
</html>