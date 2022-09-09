package main

deny[msg] {    
    input.kind == "Service"
    not input.spec.type = "NodePort"
    mdg = "Service Type should be NodePort"
}


deny[msg] {
   input.kind= "Deployment"
   not input.spec.template.spec.containers[0].securityContext.runAsNonroot = true
   msg = "Not run as root user"
}