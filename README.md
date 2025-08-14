# Kafka Monitoring Dashboard для Grafana

Этот дашборд предоставляет комплексный мониторинг Kafka кластера с четырьмя основными секциями:

## 📊 Структура дашборда

### 1. **Оборудование (Equipment)**
- График нагрузки процессора
- Текущая нагрузка процессора
- График нагрузки диска
- График нагрузки ОЗУ
- Текущая нагрузка ОЗУ

### 2. **Компоненты кластера Kafka**
- Доступность кластера
- JVM Threads State
- Request Total Time (ms)
- Кол-во текущих подключений
- Requests Per Second
- Partition Count
- Active Broker Count
- Local Time (ms)
- Request Queue Time (ms)
- Failed Producer Requests
- Under Replicated Partitions

### 3. **Очереди (Queues)**
- Размер очереди
- Кол-во partition per topic
- Динамика лага
- Очереди без сообщений за последний 24 часа
- Кол-во consumer per topic
- Общее состояние лага (с цветовой индикацией)

### 4. **Consumer**
- Bytes Consumed Rate
- Rebalance Time Max
- Скорость обработки сообщений
- Доступность
- Динамика балансировки

## 🚀 Установка

### Предварительные требования

1. **Grafana** (версия 8.0+)
2. **Prometheus** с настроенным сбором метрик Kafka
3. **Kafka Exporter** или JMX Exporter для сбора метрик Kafka

### Шаги установки

1. **Импорт дашборда:**
   - Откройте Grafana
   - Перейдите в **Dashboards** → **Import**
   - Загрузите файл `kafka-monitoring-dashboard.json`
   - Выберите источник данных Prometheus
   - Нажмите **Import**

2. **Настройка источника данных:**
   - Убедитесь, что Prometheus настроен и доступен
   - Проверьте, что метрики Kafka собираются корректно

## 📈 Метрики и их описание

### Оборудование
- `node_cpu_seconds_total` - метрики CPU
- `node_memory_MemAvailable_bytes` - доступная память
- `node_filesystem_avail_bytes` - свободное место на диске

### Kafka Cluster
- `kafka_server_replicamanager_underreplicatedpartitions` - недореплицированные партиции
- `jvm_threads_state` - состояние JVM потоков
- `kafka_network_requestmetrics_totaltimems` - общее время обработки запросов
- `kafka_server_socket_server_metrics_connection_count` - количество подключений
- `kafka_controller_kafkacontroller_partitioncount` - количество партиций
- `kafka_controller_kafkacontroller_activebrokercount` - активные брокеры

### Очереди
- `kafka_log_logendoffset - kafka_log_logstartoffset` - размер очереди
- `kafka_consumer_group_max_lag` - максимальный лаг консьюмера

### Consumer
- `kafka_consumer_fetch_manager_metrics_bytes_consumed_total` - потребленные байты
- `kafka_consumer_group_rebalance_time_max` - максимальное время ребалансировки
- `kafka_consumer_fetch_manager_metrics_records_consumed_total` - потребленные записи

## 🎨 Цветовая схема и пороги

### CPU и RAM
- 🟢 Зеленый: < 70% (CPU) / < 80% (RAM)
- 🟡 Желтый: 70-90% (CPU) / 80-90% (RAM)
- 🔴 Красный: > 90%

### Disk Usage
- 🟢 Зеленый: < 80%
- 🟡 Желтый: 80-90%
- 🔴 Красный: > 90%

### Consumer Lag
- 🟢 Зеленый: ≤ 50
- 🟡 Желтый: > 50 < 100
- 🔴 Красный: ≥ 100

## ⚙️ Настройка метрик

### Prometheus Configuration
```yaml
scrape_configs:
  - job_name: 'kafka'
    static_configs:
      - targets: ['kafka-broker:9308']
    metrics_path: /metrics
    scrape_interval: 15s
```

### Kafka Exporter Configuration
```yaml
kafka:
  server:
    port: 9308
  topic:
    filter:
      regex: ".*"
  group:
    filter:
      regex: ".*"
```

## 🔧 Кастомизация

### Добавление новых метрик
1. Откройте дашборд в режиме редактирования
2. Добавьте новый панель
3. Настройте PromQL запрос
4. Сохраните изменения

### Изменение порогов
1. Выберите панель
2. Перейдите в **Field** → **Thresholds**
3. Настройте значения и цвета
4. Сохраните

## 📝 Примечания

- Дашборд обновляется каждые 30 секунд
- Временной диапазон по умолчанию: последний час
- Все метрики основаны на стандартных Kafka JMX метриках
- Поддерживается темная тема

## 🐛 Устранение неполадок

### Метрики не отображаются
1. Проверьте подключение к Prometheus
2. Убедитесь, что Kafka Exporter работает
3. Проверьте правильность метрик в Prometheus

### Неточные данные
1. Проверьте интервал сбора метрик
2. Убедитесь в корректности PromQL запросов
3. Проверьте настройки retention в Prometheus

## 📞 Поддержка

При возникновении проблем:
1. Проверьте логи Grafana и Prometheus
2. Убедитесь в корректности конфигурации
3. Проверьте доступность метрик в Prometheus UI

---

**Версия:** 1.0  
**Совместимость:** Grafana 8.0+, Prometheus 2.0+  
**Автор:** Kafka Monitoring Dashboard