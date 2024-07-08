resource "aws_sqs_queue" "backend_queue" {
  name                      = "backend_queue"
  delay_seconds             = 90
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
}


output "backend_queue_url" {
    value = ["${aws_sqs_queue.backend_queue.url}"]
}
