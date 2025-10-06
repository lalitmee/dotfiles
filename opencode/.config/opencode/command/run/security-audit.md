---
description: Performs a comprehensive security audit of code changes, dependencies, and potential vulnerabilities
agent: build
---

Conduct a thorough security audit for: $ARGUMENTS

Please perform the following security analysis:

1. **Code Vulnerability Scan:**
   - Examine code for common security vulnerabilities (OWASP Top 10)
   - Look for SQL injection, XSS, CSRF vulnerabilities
   - Check for insecure direct object references
   - Identify authentication and authorization issues
    - Search for hardcoded secrets: !`grep -r "password|secret|key|token" . --exclude-dir=node_modules --exclude-dir=.git | grep -v ".toml" | head -10`

2. **Dependency Security:**
    - Check for known vulnerabilities in dependencies: !`npm audit --audit-level=moderate 2>/dev/null || echo "No package.json found or npm not available"`
   - Identify outdated packages with security issues
   - Look for packages with excessive permissions
   - Check for suspicious or unmaintained dependencies

3. **Input Validation:**
   - Verify proper input sanitization and validation
   - Check for buffer overflow possibilities
   - Look for unvalidated redirects and forwards
   - Examine file upload security (if applicable)

4. **Authentication & Authorization:**
   - Review authentication mechanisms
   - Check session management security
   - Verify proper access controls
   - Look for privilege escalation vulnerabilities

5. **Data Protection:**
   - Check for sensitive data exposure
   - Verify encryption usage for sensitive data
   - Look for insecure data storage practices
   - Check for proper logging without exposing secrets

6. **Infrastructure Security:**
   - Review configuration files for security misconfigurations
   - Check environment variable usage
   - Look for exposed debug information
   - Verify HTTPS/TLS usage

7. **Recent Changes Analysis:**
    - Examine recent commits for security implications: !`git log --oneline -10`
   - Check if new code introduces security risks
   - Verify that security best practices are followed

8. **Security Recommendations:**
   For each finding, provide:
   - **Severity Level:** Critical/High/Medium/Low
   - **Description:** Clear explanation of the vulnerability
   - **Impact:** Potential consequences if exploited
   - **Remediation:** Step-by-step fix instructions
   - **Prevention:** How to avoid similar issues in the future

9. **Compliance Check:**
   - Check against common security standards (OWASP, NIST)
   - Verify adherence to security coding guidelines
   - Look for compliance with data protection regulations

Please provide a comprehensive security report with prioritized findings and actionable remediation steps.

