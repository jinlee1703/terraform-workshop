# 2023.09.26: 서브넷 리팩토링
moved {
  from = aws_subnet.public
  to = aws_subnet.public[0]
}

moved {
  from = aws_subnet.private_az1
  to = aws_subnet.private["jinwoo-private-001"]
}