resource "aws_cloudwatch_event_rule" "MonitorCert-1000" {
  description         = "Monitor acm cert at monday 10:00"
  event_bus_name      = "default"
  is_enabled          = true
  name                = "MonitorCert-1000"
  schedule_expression = "cron(30 10 ? * 1 *)"
}

resource "aws_cloudwatch_event_target" "xxx-cert-monitor-event-target" {
  arn  = aws_lambda_function.xxx-cert-monitor.arn
  rule = aws_cloudwatch_event_rule.MonitorCert-1000.id
}
