{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": ["${trusted_role}"]
      },
      "Action": "sts:AssumeRole"
    }
  ]
}

