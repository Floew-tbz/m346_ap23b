provider "aws" {
  region = "us-east-1"  # Die Region kann angepasst werden
}

resource "aws_instance" "db_server" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = "t2.micro"

  # User Data für Cloud-Init Skript
  user_data = <<-EOF
    #cloud-config
    users:
      - name: ubuntu
        sudo: ALL=(ALL) NOPASSWD:ALL
        groups: users, admin
        home: /home/ubuntu
        shell: /bin/bash
        ssh_authorized_keys:
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCNs6alL8GS2ora3KgLbTkHOaBcsxJMHO9MCuPfHC4W1DejDzfjVD2M61k6afnhNN6HLkkxFMPuxWxleujELK0XxIX97oqasBoBtLOvwpvQlNAmjj5RwyKpaH6JT8DpCrifbdCHkZiGpC3M+lcf960VCcdy+AnTw1CQu0mc53OqasQVVC9+DfAtHq8wqHqnm94BafYmvEof4ZUJmgSC800fsDuV0uclXsQOaHqYF1iE1KNJapHkvj7Ct8p+3uKGWNhr+NORDuikAxAqdin/vd0tkanO0NHbo8PoOogBNpIbTqr4+PRfqIB8dnTsSZ7e9j06JlXSX5X9vXXJnAUBhE3t aws-key
          - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID7isuCUjLHzcLtgbCi9gdf+p/urcqTQfhjwvy1+6GE0
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0WGP1EZykEtv5YGC9nMiPFW3U3DmZNzKFO5nEu6uozEHh4jLZzPNHSrfFTuQ2GnRDSt+XbOtTLdcj26+iPNiFoFha42aCIzYjt6V8Z+SQ9pzF4jPPzxwXfDdkEWylgoNnZ+4MG1lNFqa8aO7F62tX0Yj5khjC0Bs7Mb2cHLx1XZaxJV6qSaulDuBbLYe8QUZXkMc7wmob3PM0kflfolR3LE7LResIHWa4j4FL6r5cQmFlDU2BDPpKMFMGUfRSFiUtaWBNXFOWHQBC2+uKmuMPYP4vJC9sBgqMvPN/X2KyemqdMvdKXnCfrzadHuSSJYEzD64Cve5Zl9yVvY4AqyBD lehrer-key
          - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCz/wpWmsCxaQyuNFrIachc/q9nUdByoUcBcicl/wnKLFktKp6du9np9Uhmo4M0tVHNnWCt5uNEi2ks/0XEbg2J+4heuAAKEDr/TVbgabiWGclYKpEWZvmw8gsQwfpAKVG4aS2re7wB2uhw82ZqzJVpGm3ne+sNnz5uVrxN8HUnuR2OWJD6bA9l/fBmE6zdObVXgrCJGjZmVyB5GMeTDJKExgoBpLggZn9CNdu7Sx989xtNLehu6SWM+mGCq9Lcu7usiPG+SuEb8XynYaCOnv8+Oko6SYeJ9Omq/E7Eg6vZHqCbBQ81TIZrGKcikLmF2xP7EOprGOSPVewke7ak7vvmOI+p/RfIAyXj1+GYny+esk9G+qDRFXP9uiIlMfH1oGkQkztvSDMH+EOHqgY66NWQJPj83CaWH/euR0MROHXjm1ar3RuN9qcASAnzCOQQ1FMwFkpIV5x0NDRx0Zp1rLt8ZUFykmIuHZI4g9u6RdAiuWUxx9/eF0fXZa6Ju7GEMKeMtZxJJjmB/WCOylbkT+NPw5RcxgyRLKmUAicnYKXBmULY3pQM/Ui8KiCyJqRbLDBAR+XZYsZ7X5uhcuteu8KIfA2xEbInB4Q3c0DnnSih+GEC4pEbz+NOfeCpLJEn4gfyV1S9S08sG62ls8NPFociA9aWmE1oXfcqwvOkkYhxOw== lehrer-key2
    ssh_pwauth: false
    disable_root: false
    package_update: true
    packages:
      - curl
      - wget
      - mariadb-server
    runcmd:
      - sudo mysql -sfu root -e "GRANT ALL ON *.* TO 'admin'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;"
      - sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mysql/mariadb.conf.d/50-server.cnf
      - sudo systemctl restart mariadb.service
  EOF

  vpc_security_group_ids = ["sg-0e0b25daf59c8c7f0"]

  tags = {
    Name = "DBServer"
  }
}