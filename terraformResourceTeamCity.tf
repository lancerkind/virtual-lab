resource "aws_instance" "ec2_aec_teamcity" {
  #count = 3
  count = 0
  ami = "ami-80861296"
  instance_type = "m4.large"
  key_name = aws_key_pair.aec_key_pair.key_name
  security_groups = ["${aws_security_group.aec_sg_teamcity.name}"]
  
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
#      private_key = file("~/.ssh/id_rsa")
private_key = "-----BEGIN RSA PRIVATE KEY-----Proc-Type: 4,ENCRYPTEDDEK-Info: AES-128-CBC,7C20C3F5D520721C0E2038F0EE6E8A1FJvnOfa4Wi6cm5J/6RlsAjWMVeIy+P5ezo8isDkPewx5z0tGJ+fkLLz414SpxV5UWjXtroq+ErDCR4QLngtSRdz+E+w44OGJKPSWzMjJocFhMuGVpj3phjnA0PS2b2mzNSetEi0LsAH0hupDo0YJ9/64hQ+BNu6FrwY251Q7D+cCimeHQq7pINCx3el/qbWU63/NQZ4swDKoWEEVFjNYbAB5KnOWAiZFbtqSCtfN389bpXyCumwyTrLWj8IvvK4p6yuOeSNco7NZHcvYIge/a+dqigFqwGbTnx1IQ2T1GKEgLBYElpw0MESPc1K9HZM0JyCGou2oyYOd9DzUTGUobjyYkOG4zSV5WV/AU4bILhjBK+wqnEW/yQxhmJOl6kDAs+P3lFtNmoxCd0u7wvudJo8TO7TWH5KiE8KH9zcZY5abnwauwchpGUXtXN+kslGCHZd7UcGq5pe6UvX1dxL5zpsnJFQP+Nv02RJH3b8UPdeJm6NJbRdULMLvtearhv/6WCAuzBXsgcHAkUfJZimNYCofxriKYjQeVDjC8tQri3vAl0lU9ygxMm0T2EVcBX5QTSAofusdGpI2MEmcij04Ss+J7dHGEhSu4HTV5pINERYDJ4eMkl3bK/tnSs/jorP7TLS+VBDB7v/r7Fthfrg7pkEQ1weWNc3gsh5t+fSacsH11NUby1u+YvxH+4FBDy0t16uTm9bVkJDB2XoivKtgbrcBASl6Sk/AYNR05q88tPIww9/O+WaxM1Nn7uEjkhAttafeDWwp0/sYhVKzCFTqp4Spp2ZNC76LA4thFJE8pD2mrkkpf+wLA/XlsE9/kyeZYYZxKL5kJAbDo30JgEYUWYBkIcWuWbgeFtsPaUKWajIyLfbH8s5M5KyXmohdcbohipv+33HEQr+XNL03ATpur8pMMcEN34CPDVSSM456kVXmR6TAY3vmaJHutah3TFhjMzM+HScz/L+00t/LcyXpkDeZImthMkpLerklEd2Wab+/g3Zs0IHhEE4+eVBiWrQFJCJ2xAvwfabDwclCaJYq/hyXL+J3rjC6tJcohYrdpgoH6/OhW3Z04aGKQnn28QAwTuVhAM0bUXrOzf34dM1MHZTakpDl9Zez78A/rTHSuXljzMjlpK+mLjQDa81+JIj0Y/5rMMzEI1AdUND54+WOESs2f37TQ1z7HJapyarBv6U6+k0YSj02E2wdQ91Q3dIEK82+QvwDPEI/5+eWx7M0oPClCpWr+x7VFD9kwZA4Vy9iJ6WzGjbVTttGbNdIgW1WRzVR2KGPmVpk62sYUK9zcte7MZHQQTbjGmoEXEvX0UAGCRkqHCFfU/yoOydTf61gKK/Ajy5jBEqkxzS6HGQnNGSN/6XEu8XvKM3u8bY14qF7l1nW/C/lCfhUcQ+RYUBNaOX+1wKUA0UoZs3Am4T1T6P3Eyk4gHHjGxCObqOm8Vxn98Vf1Y7OiZKiA+w0YdlxCv4kdIk7bvbFkvI98FAhqO2aHmxsmy8YOwmhl1OMXv2A8iZXcxwBCMjWmRdy5ReZ0jrgICezo+vRmgxoO1Ap5TC/zd1ZhcqU78a88V1vhdPI2zbvgkKdNVfhr+IFQVs/T-----END RSA PRIVATE KEY-----\n\n"
    }
    script = "provisionTeamCity.sh"
  }
  
  provisioner "remote-exec" {
    connection {
      host = self.public_ip
      type = "ssh"
      user = "ubuntu"
      #private_key = file("~/.ssh/id_rsa")
      private_key = "-----BEGIN RSA PRIVATE KEY-----Proc-Type: 4,ENCRYPTEDDEK-Info: AES-128-CBC,7C20C3F5D520721C0E2038F0EE6E8A1FJvnOfa4Wi6cm5J/6RlsAjWMVeIy+P5ezo8isDkPewx5z0tGJ+fkLLz414SpxV5UWjXtroq+ErDCR4QLngtSRdz+E+w44OGJKPSWzMjJocFhMuGVpj3phjnA0PS2b2mzNSetEi0LsAH0hupDo0YJ9/64hQ+BNu6FrwY251Q7D+cCimeHQq7pINCx3el/qbWU63/NQZ4swDKoWEEVFjNYbAB5KnOWAiZFbtqSCtfN389bpXyCumwyTrLWj8IvvK4p6yuOeSNco7NZHcvYIge/a+dqigFqwGbTnx1IQ2T1GKEgLBYElpw0MESPc1K9HZM0JyCGou2oyYOd9DzUTGUobjyYkOG4zSV5WV/AU4bILhjBK+wqnEW/yQxhmJOl6kDAs+P3lFtNmoxCd0u7wvudJo8TO7TWH5KiE8KH9zcZY5abnwauwchpGUXtXN+kslGCHZd7UcGq5pe6UvX1dxL5zpsnJFQP+Nv02RJH3b8UPdeJm6NJbRdULMLvtearhv/6WCAuzBXsgcHAkUfJZimNYCofxriKYjQeVDjC8tQri3vAl0lU9ygxMm0T2EVcBX5QTSAofusdGpI2MEmcij04Ss+J7dHGEhSu4HTV5pINERYDJ4eMkl3bK/tnSs/jorP7TLS+VBDB7v/r7Fthfrg7pkEQ1weWNc3gsh5t+fSacsH11NUby1u+YvxH+4FBDy0t16uTm9bVkJDB2XoivKtgbrcBASl6Sk/AYNR05q88tPIww9/O+WaxM1Nn7uEjkhAttafeDWwp0/sYhVKzCFTqp4Spp2ZNC76LA4thFJE8pD2mrkkpf+wLA/XlsE9/kyeZYYZxKL5kJAbDo30JgEYUWYBkIcWuWbgeFtsPaUKWajIyLfbH8s5M5KyXmohdcbohipv+33HEQr+XNL03ATpur8pMMcEN34CPDVSSM456kVXmR6TAY3vmaJHutah3TFhjMzM+HScz/L+00t/LcyXpkDeZImthMkpLerklEd2Wab+/g3Zs0IHhEE4+eVBiWrQFJCJ2xAvwfabDwclCaJYq/hyXL+J3rjC6tJcohYrdpgoH6/OhW3Z04aGKQnn28QAwTuVhAM0bUXrOzf34dM1MHZTakpDl9Zez78A/rTHSuXljzMjlpK+mLjQDa81+JIj0Y/5rMMzEI1AdUND54+WOESs2f37TQ1z7HJapyarBv6U6+k0YSj02E2wdQ91Q3dIEK82+QvwDPEI/5+eWx7M0oPClCpWr+x7VFD9kwZA4Vy9iJ6WzGjbVTttGbNdIgW1WRzVR2KGPmVpk62sYUK9zcte7MZHQQTbjGmoEXEvX0UAGCRkqHCFfU/yoOydTf61gKK/Ajy5jBEqkxzS6HGQnNGSN/6XEu8XvKM3u8bY14qF7l1nW/C/lCfhUcQ+RYUBNaOX+1wKUA0UoZs3Am4T1T6P3Eyk4gHHjGxCObqOm8Vxn98Vf1Y7OiZKiA+w0YdlxCv4kdIk7bvbFkvI98FAhqO2aHmxsmy8YOwmhl1OMXv2A8iZXcxwBCMjWmRdy5ReZ0jrgICezo+vRmgxoO1Ap5TC/zd1ZhcqU78a88V1vhdPI2zbvgkKdNVfhr+IFQVs/T-----END RSA PRIVATE KEY-----\n\n"
    }
    inline = ["sudo reboot now"]
  }
  tags = {
    Name = "Agile Engineering Class TeamCity ${format("%03d", count.index)}"
  }
}
