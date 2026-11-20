#4 завдання: канал доставки сповіщень (SNS + Email) 
resource "aws_sns_topic" "alerts" {
  name = "cloud-labs-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "iryna.lutsan.ir.2024@lpnu.ua"
}

#правило тривоги: латентність p95 понад 500 мс (0.5 с) протягом 2 хвилин
resource "aws_cloudwatch_metric_alarm" "high_latency_alarm" {
  alarm_name          = "cloud-labs-high-latency-p95"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "TargetResponseTime"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  extended_statistic  = "p95"
  threshold           = 0.5
  alarm_description   = "Alert when p95 latency exceeds 500ms for 2 minutes"

  dimensions = {
    LoadBalancer = aws_lb.main.arn_suffix
  }

  alarm_actions = [aws_sns_topic.alerts.arn]
  ok_actions    = [aws_sns_topic.alerts.arn]
}

#3 завдання: панель моніторингу (CloudWatch Dashboard) 
resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "cloud-labs-monitoring-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      #кількість екземплярів (бажана і фактична)
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "1. Кількість екземплярів (Desired vs Running)"
          region  = "us-east-1"
          stat    = "Average"
          period  = 60
          metrics = [
            ["ECS/ContainerInsights", "DesiredTaskCount", "ClusterName", aws_ecs_cluster.main.name, "ServiceName", aws_ecs_service.main.name],
            [".", "RunningTaskCount", ".", ".", ".", "."]
          ]
        }
      },
      #завантаження процесора (CPU %)
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          title   = "2. Завантаження процесора (CPU Utilization %)"
          region  = "us-east-1"
          stat    = "Average"
          period  = 60
          metrics = [
            ["AWS/ECS", "CPUUtilization", "ClusterName", aws_ecs_cluster.main.name, "ServiceName", aws_ecs_service.main.name]
          ]
        }
      },
      #кількість запитів за хвилину
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 8
        height = 6
        properties = {
          title   = "3. Кількість запитів за хвилину"
          region  = "us-east-1"
          stat    = "Sum"
          period  = 60
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.main.arn_suffix]
          ]
        }
      },
      #латентність p95
      {
        type   = "metric"
        x      = 8
        y      = 6
        width  = 8
        height = 6
        properties = {
          title   = "4. Латентність p95 (сек)"
          region  = "us-east-1"
          stat    = "p95"
          period  = 60
          metrics = [
            ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", aws_lb.main.arn_suffix]
          ]
        }
      },
      #кількість відповідей 5xx
      {
        type   = "metric"
        x      = 16
        y      = 6
        width  = 8
        height = 6
        properties = {
          title   = "5. Помилки сервера (HTTP 5xx)"
          region  = "us-east-1"
          stat    = "Sum"
          period  = 60
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", aws_lb.main.arn_suffix],
            [".", "HTTPCode_ELB_5XX_Count", ".", "."]
          ]
        }
      }
    ]
  })
}