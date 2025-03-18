# Import the existing AWS Connect instance
import {
  to = aws_connect_instance.example
  id = "451f789b-5e50-441a-a355-795ce8ba735f"
}

# AWS Connect instance
resource "aws_connect_instance" "example" {
  instance_alias             = "p3f-learn"
  identity_management_type   = "CONNECT_MANAGED"
  inbound_calls_enabled      = true
  outbound_calls_enabled     = true
}

# AWS Connect Flow
resource "aws_connect_contact_flow" "aws_flow" {
  instance_id  = aws_connect_instance.example.id
  name         = "Aws-flow"
  type         = "CONTACT_FLOW"
  description  = "Example flow for contact management"
  content      = jsonencode({
    "Start" : {
      "Actions": []
    }
  })
}

resource "aws_connect_contact_flow" "aws_customer_queue_flow" {
  instance_id  = aws_connect_instance.example.id
  name         = "Aws-customerqueue"
  type         = "CUSTOMER_QUEUE"
  description  = "Example flow for customer queue"
  content      = jsonencode({
    "Start" : {
      "Actions": []
    }
  })
}

resource "aws_connect_contact_flow" "aws_agent_hold_flow" {
  instance_id  = aws_connect_instance.example.id
  name         = "aws-agentholdflw"
  type         = "AGENT_HOLD"
  description  = "Example flow for agent hold"
  content      = jsonencode({
    "Start" : {
      "Actions": []
    }
  })
}

# AWS Connect Queue
resource "aws_connect_queue" "aws_customer_queue" {
  instance_id         = aws_connect_instance.example.id
  name                = "aws-customerqueue"
  description         = "Queue for handling customer calls"
  max_contacts        = 100
  hours_of_operation_id = "arn:aws:connect:us-east-1:039289871235:instance/451f789b-5e50-441a-a355-795ce8ba735f/operating-hours/9c5e1b13-e0a0-4530-bd31-610762593c2f"  # Replace with your actual ID
}

resource "aws_connect_queue" "aws_transfer_queue" {
  instance_id         = aws_connect_instance.example.id
  name                = "aws-transferqueue"
  description         = "Queue for transferring calls"
  max_contacts        = 100
  hours_of_operation_id = "arn:aws:connect:us-east-1:039289871235:instance/451f789b-5e50-441a-a355-795ce8ba735f/operating-hours/9c5e1b13-e0a0-4530-bd31-610762593c2f"  # Replace with your actual ID
}

# AWS Connect Routing Profile
resource "aws_connect_routing_profile" "aws_customercare_routing_profile" {
  instance_id     = aws_connect_instance.example.id
  name            = "Aws-customercare"
  description     = "Routing profile for handling customer interactions"

  media_concurrencies {
    channel = "VOICE"
    concurrency = 5
  }

  media_concurrencies {
    channel = "CHAT"
    concurrency = 3
  }

  default_outbound_queue_id = aws_connect_queue.aws_customer_queue.id
}

resource "aws_connect_routing_profile" "aws_transfer_routing_profile" {
  instance_id     = aws_connect_instance.example.id
  name            = "aws-transfer"
  description     = "Routing profile for handling customer transfer interactions"

  media_concurrencies {
    channel = "VOICE"
    concurrency = 5
  }

  media_concurrencies {
    channel = "CHAT"
    concurrency = 3
  }

  default_outbound_queue_id = aws_connect_queue.aws_customer_queue.id
}

#
