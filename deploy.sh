#!/bin/bash

# Скрипт для развертывания Kafka Monitoring Dashboard
# Автор: Kafka Monitoring Dashboard

set -e

echo "🚀 Запуск развертывания Kafka Monitoring Dashboard..."

# Проверка наличия Docker и Docker Compose
if ! command -v docker &> /dev/null; then
    echo "❌ Docker не установлен. Пожалуйста, установите Docker."
    exit 1
fi

if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose не установлен. Пожалуйста, установите Docker Compose."
    exit 1
fi

# Создание необходимых директорий
echo "📁 Создание директорий..."
mkdir -p grafana/provisioning/dashboards
mkdir -p grafana/provisioning/datasources

# Копирование дашборда в Grafana
echo "📊 Копирование дашборда..."
cp kafka-monitoring-dashboard.json grafana/provisioning/dashboards/

# Создание конфигурации источника данных Grafana
echo "🔧 Настройка источника данных Grafana..."
cat > grafana/provisioning/datasources/prometheus.yml << EOF
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    editable: true
EOF

# Обновление Docker Compose для использования локальных директорий
echo "🐳 Обновление Docker Compose конфигурации..."
sed -i 's|./kafka-monitoring-dashboard.json:/etc/grafana/provisioning/dashboards/kafka-dashboard.json|./grafana/provisioning/dashboards:/etc/grafana/provisioning/dashboards|g' docker-compose.yml

# Запуск сервисов
echo "🔄 Запуск сервисов..."
docker-compose up -d

# Ожидание запуска сервисов
echo "⏳ Ожидание запуска сервисов..."
sleep 30

# Проверка статуса сервисов
echo "🔍 Проверка статуса сервисов..."
docker-compose ps

# Проверка доступности сервисов
echo "🌐 Проверка доступности сервисов..."

# Prometheus
if curl -s http://localhost:9090 > /dev/null; then
    echo "✅ Prometheus доступен на http://localhost:9090"
else
    echo "❌ Prometheus недоступен"
fi

# Grafana
if curl -s http://localhost:3000 > /dev/null; then
    echo "✅ Grafana доступен на http://localhost:3000"
    echo "   Логин: admin"
    echo "   Пароль: admin"
else
    echo "❌ Grafana недоступен"
fi

# Kafka Exporter
if curl -s http://localhost:9308 > /dev/null; then
    echo "✅ Kafka Exporter доступен на http://localhost:9308"
else
    echo "❌ Kafka Exporter недоступен"
fi

# Node Exporter
if curl -s http://localhost:9100 > /dev/null; then
    echo "✅ Node Exporter доступен на http://localhost:9100"
else
    echo "❌ Node Exporter недоступен"
fi

# Alertmanager
if curl -s http://localhost:9093 > /dev/null; then
    echo "✅ Alertmanager доступен на http://localhost:9093"
else
    echo "❌ Alertmanager недоступен"
fi

echo ""
echo "🎉 Развертывание завершено!"
echo ""
echo "📋 Следующие шаги:"
echo "1. Откройте Grafana: http://localhost:3000"
echo "2. Войдите с учетными данными: admin/admin"
echo "3. Импортируйте дашборд Kafka Monitoring"
echo "4. Настройте источник данных Prometheus"
echo ""
echo "🔧 Настройка Kafka Exporter:"
echo "- Убедитесь, что Kafka доступен по адресу kafka-broker:9092"
echo "- Или измените адрес в docker-compose.yml"
echo ""
echo "📊 Доступные сервисы:"
echo "- Grafana: http://localhost:3000"
echo "- Prometheus: http://localhost:9090"
echo "- Alertmanager: http://localhost:9093"
echo "- Kafka Exporter: http://localhost:9308"
echo "- Node Exporter: http://localhost:9100"
echo ""
echo "🛑 Для остановки используйте: docker-compose down"
echo "🔄 Для перезапуска используйте: docker-compose restart"