## Q & A (Load Balancers, Cloud Armor, and Cloud CDN):

## Load Balancers

    Q1 - How does load balancing contribute to Fault tolerance? What about high availability? 
    A1 - The very function of a load balancer (directing and controlling internet traffic between client requests and the application's servers) contributes to fault tolerance and high availability by improving the application's availability, scalability, security, and performance/
    
    Resource/Documentation/Reference - https://aws.amazon.com/what-is/load-balancing/
    How Resource/Documentation/Reference was used - Leveraged the content under the header "What are the benefits of load balancing?"

    
    Q2 - Do global load balancers decrease latency for end users? Why or why not? 
    A2 - Yes, global load balancers decrease latency for end users. This is done by an advanced method called Global Server Load Balancing (GSLB).GSLB provides a global application resilience, performance, and availability by logically routing user traffic to the most optimal global server. This results in latency being reduced.
    
    Resource/Documentation/Reference - https://www.splunk.com/en_us/blog/learn/global-server-load-balancing-gslb.html
    How Resource/Documentation/Reference was used - Leveraged the content under "Key Takeaways", "What is Global Server Load Balancing?", and "How GSLB works"


    Q3 - What are LB health checks for? Do we always need them? Is a LB different from a reverse proxy? 
    A3 - LB health checks monitor the status and condition of the backend servers that communicate with the LB. Yes, you always need health checks for your LB because you want to have observability into the underlining servers (don't want a black box situation in case something breaks). LB is different from a reverse proxy in that a LB is a single entry point that distributes traffic to multiple backend servers, while a reverse proxy acts as an intermediary between clients and servers that handles requests and responses via caching, security features, etc.
    
    Resource/Documentation/Reference - https://www.haproxy.com/glossary/what-is-a-health-check and https://www.geeksforgeeks.org/system-design/reverse-proxy-vs-load-balancer/
    How Resource/Documentation/Reference was used - (Link 1) => Leveraged the content under "What is a health check" and "How do health checks work" AND (Link 2) => Leveraged the content under "What are the differences between Reverse Proxy and Load Balancer?"


    Q4 - What are LB routing rules and URL maps for? Give an example or two of them in use. 
    A4 - LB routing rules are used for routing ingress traffic from the client (via the load balancer) to an application's backend servers based on the ingress traffic from the client matching with the routing rule's predefined match condition(s), resulting in the execution of the corresponding route action(s). URL maps are leveraged by Google Cloud Application Load Balancers in order to route HTTP and HTTPS requests to backend services or backend buckets.

    LB routing rule example — A load balancer routing rule that forwards ingress traffic only when the request path exactly matches /videos.
    URL maps example - An external Application Load Balancer is configured to use a single URL map to route requests to different destinations based on the rules configured in the URL map (e.g., Requests for https://example.com/video go to one backend service, Requests for https://example.com/audio go to a different backend service, Requests for https://example.com/images go to a Cloud Storage backend bucket, and Requests for any other host and path combination go to a default backend service)
    
    Resource/Documentation/Reference - https://docs.oracle.com/en-us/iaas/Content/Balance/Tasks/routing-policy_management.htm and https://docs.cloud.google.com/load-balancing/docs/url-map-concepts
    How Resource/Documentation/Reference was used - (Link 1) => Leveraged the content under "Routing Policies for Load Balancers" and "Supported Match Types" AND (Link 2) => Leveraged the content under "URL maps overview"


    Q5 - Explain what an anycast IP address is used for in the context of a global load balancer.
    A5 - An anycast IP address is used to intelligently direct user traffic to the closest backend location (e.g., GCP, other public clouds like AWS and Azure, and/or on-premises) resulting in minimal latency and higher availability
    
    Resource/Documentation/Reference - https://cloud.google.com/load-balancing (extra credit link => https://oneuptime.com/blog/post/2026-02-17-how-to-implement-a-global-anycast-architecture-for-low-latency-applications-on-gcp/view)
    How Resource/Documentation/Reference was used - Leveraged the content under "Unify your global application delivery"

## Cloud Armor

    Q1 - What does cloud armor offer?
    A1 - Cloud Armor offers the following features: Pre-defined WAF rules to mitigate OWASP Top 10 risks, Rich rules language for web application firewall, Visibility and monitoring, Logging, Preview mode, Policy framework with rules, IP-based and geo-based access control, Support for hybrid and multicloud deployments, and Named IP Lists

    Resource/Documentation/Reference - https://cloud.google.com/security/products/armor#all-features
    How Resource/Documentation/Reference was used - Leveraged the content under "All features"


    Q2 - Why is it used in the first place?
    A2 - Cloud armor is primarily used to defend against L3 and L7 DDoS attacks

    Resource/Documentation/Reference - https://cloud.google.com/security/products/armor#benefits
    How Resource/Documentation/Reference was used - Leveraged the content under "Benefits"


    Q3 - What layer in the OSI model does it operate at? Why is this important and how is this firewall different from VPC firewall rules?
    A3 - Cloud Armor operates at Layer 3, 4, and 7 of the OSI model. This is important because DDoS attacks target specific layers of a network connection - application layer attacks target layer 7 and protocol layer attacks target layers 3 and 4. Cloud Armor security policies and VPC firewall rules are different in the following matter: 1. Cloud Armor security policies provide edge security as well as act on client traffic to Google Front Ends (GFEs) while 2. VPC firewall rules allow or deny traffic to and from your application's backends

    Resource/Documentation/Reference - https://docs.cloud.google.com/armor/docs/cloud-armor-overview (extra credit link => https://cloud.google.com/blog/topics/developers-practitioners/when-should-i-use-cloud-armor), https://www.cloudflare.com/learning/ddos/glossary/open-systems-interconnection-model-osi/, and https://docs.cloud.google.com/armor/docs/integrating-cloud-armor
    How Resource/Documentation/Reference was used - (Link 1) => Leveraged the content under "How Cloud Armor works", (Link 2) => Leveraged the content under "What is the OSI Model?", AND (Link 3) => Leveraged the content under "Cloud Armor and VPC firewall rules"


    Q4 - What are rate based rules for?
    A4 - Rate based rules in Cloud Armor help protect applications from high request volumes that flood backend instances and can block access for legitimate users.

    Resource/Documentation/Reference - https://docs.cloud.google.com/armor/docs/rate-limiting-overview
    How Resource/Documentation/Reference was used - Leveraged the content under "Rate limiting overview"


    Q5 - What is reCAPTCHA and how does it relate to this service? 
    A5 - reCAPTCHA is a bot blocker that protects websites from spam, abuse, and fraud. reCAPTCHA has an integration feature with Cloud Armor that lets reCAPTCHA be deployed as a service within Cloud Armor so that abusive traffic can be detected and blocked before it even reaches your web application's infrastructure.

    Resource/Documentation/Reference - https://cloud.google.com/security/products/recaptcha
    How Resource/Documentation/Reference was used - Leveraged the content under "How It Works" and "Integrate with your web application firewall (WAF)"

## CDN

    Q1 - What are POPs used for?
    A1 - Points of Presence (POPs) are used for handling traffic distribution, improving load times, and ensuring higher availability within a CDN

    Resource/Documentation/Reference - https://www.cloudns.net/blog/what-is-a-point-of-presence-pop-and-why-does-it-matter/
    How Resource/Documentation/Reference was used - Leveraged the content under "What is a Point of Presence (PoP)?"


    Q2 - What kind of files are served with Cloud CDN?
    A2 - Cloud CDN serves web and media content (static content, dynamic content, video streaming, and large gaming and software downloads) 

    Resource/Documentation/Reference - https://cloud.google.com/blog/topics/developers-practitioners/what-cloud-cdn-and-how-does-it-work and https://cloud.google.com/cdn
    How Resource/Documentation/Reference was used - (Link 1) => Leveraged the content under "How to use Cloud CDN" AND (Link 2) => Leveraged the content under "Common Uses"


    Q3 - What services can be used with cloud CDN for the source of content (the origin)?
    A3 - Google Compute Engine, GKE Ingress, GKE Gateway backends, and Cloud Storage buckets

    Resource/Documentation/Reference - https://docs.cloud.google.com/cdn/docs/overview
    How Resource/Documentation/Reference was used - Leveraged the content under "How Cloud CDN works"


    Q4 - Does Cloud CDN help protect against any types of malicious actors or cyberattacks? Explain. 
    A4 - Cloud CDN helps protect against malicius actors and cyberattacks by allowing you to programmatically sign URLs and cookies to limit video segment access to authorized users only. The signature is validated at the CDN edge and unauthorized requests are blocked.

    Resource/Documentation/Reference - https://www.geeksforgeeks.org/cloud-computing/what-is-google-cloud-cdn/
    How Resource/Documentation/Reference was used - Leveraged the content under "Security with Cloud CDN"


    Q5 - Should an enterprise always use cloud CDN? Why or why not? 
    A5 - No. An enterprise's use of Cloud CDN depends entirely on the enterprise's use case. For example, if an enterprise has users all over the globe then leveraging Cloud CDN makes sense. But if the enterprise has users locally then Cloud CDN will not add much (if any) benefit.

    Resource/Documentation/Reference - https://www.reddit.com/r/webdev/comments/qk39tv/is_there_a_reason_why_you_should_or_shouldnt_use/
    How Resource/Documentation/Reference was used - Leveraged the content under the post for the reddit user "pumpkinpie4224"


    Q6 - What is TTL and how does it control content “freshness”? 
    A6 - TTL (time to live) is the amount of time an object can remain in Cloud CDN cache before it is considered stale and revalidated or refreshed from the origin. A higher TTL usually means fewer origin fetches for content that changes infrequently, while a lower TTL causes cached content to expire sooner and be refreshed more often. 

    Resource/Documentation/Reference - https://cloud.google.com/blog/topics/developers-practitioners/what-cloud-cdn-and-how-does-it-work and https://www.fastly.com/learning/cdn/what-is-time-to-live-ttl
    How Resource/Documentation/Reference was used - (Link 1) => Leveraged the content under "How does Cloud CDN work?" AND (Link 2) => Leveraged the content under "TTL best practices"

## Runbook:
    End Goal:
    A fully configured external application global load balancer that will use a Managed Instance Group (MIG) as the backend. This configuration will be done via ClickOps.

    Prerequisites:
    - GCP account access with proper permissions
    - Instance Template
    - Health check config
    - Compute Engine API Enabled

    Follow these Steps:
    - Go to the GCP Console
        1. Navigate to the GCP Compute Engine
        2. Go to Instance Groups in navigation menu
        3. Click on "Create Instance Group"
    - Ensure the instance group is a "Managed Instance Group (Stateless)"
    - Make sure the instance group has a name that contains the team name and date
    - Add an informative description
    - Choose the correct instance template => NOTE: for this runbook, select a template that is running the supera.sh userscript
    - Do not set the number of instances (the MIG autoscaler will handle this)
    - Under "Location" (verify that the instance group will manage instances across multiple zones)
        * ensure "multiple zones" is selected
        * choose at least 3 zones (per company policy)
    - Under "Autoscaling" (How to enable autoscaling) => YOU MAY NEED TO REMOVE THIS
        * click "Configure Autoscaling"
        * minimum should be the same as the amount of zones
        * maximum will be determined by team needs
        * autoscaling signals can typically be CPU but developers should supply this
    - Under "autohealing" (How to enable autohealing)
        * select one of the existing health check configurations
        * initial delay needs to be *at least* the amount of time it takes for app to bootstrap entirely
        * default action should be "repair instance"
    - Click Create

    - In the search bar type Load balancing and click on Load balancing when it appears in the search query
    - Click Create load balancer
    - For Type of load balancer, select Application Load Balancer (HTTP/HTTPS) then click Next
    - For Public facing or internal, select Public facing (external) then click Next
    - For Global or single region deployment, select Best for global workloads then click Next
    - For Load balancer generation, select Global external Application Load Balancer then click Next
    - Click Configure

    - Create global external Application Load Balancer
        * Within the field Load Balancer name *, enter a name for the load balancer
        * Under Frontend configuration, do the following:
            1. Enter a name
            2. Provide a description
            3. Keep protocol as HTTP
            4. Keep IP version as IPV4
            5. Keep IP address as Ephemeral (Automatic)
            6. Keep Port at 80
            7. Click Done
        * Under Backend configuration, do the following:
            1. Click the dropdown field for Backend services & backend buckets
            2. Click Create a backend service
            3. Enter a name
            4. Provide a description
            5. Keep Backend type as Instance group
            6. Keep Protocol type as HTTP
            7. Keep Named port as http
            8. Keep Timeout at 30
            9. Keep IP address selection policy as Only IPv4
            10. Select a Health check
            11. Keep IP stack type as IPv4 (single-stack) => This is under Backends
            12. Select an Instance group
            13. Put 80 under Port numbers *
            14. Keep Balancing mode at Utilization
            15. Keep Traffic duration at Default (Short)
            16. Keep Maximum backend utilization at 80
            17. Keep Maximum RPS as is
            18. Keep Scope as per instance
            19. Keep Capacity as 100
            20. Keep Backend preference level as None
            21. Deselect Enable Cloud CDN => This is under Cloud CDN
            22. Under the Cloud Armor section, leave all the fields as is (default values)
            23. Under the Advanced Configurations section, leave all the fields as is (default values)
            24. Click Create
        * Staying under Backend configuration, do the following:
            1. Click the dropdown field for Backend services & backend buckets
            2. Click Create a backend bucket
            3. Enter a name
            4. Provide a description
            5. Click Browse in the Cloud Storage bucket * field and select a bucket
            6. Deselect Enable Cloud CDN
            7. Click Create
        * Under Routing rules, do the following:
            1. Keep Mode as Simple host and path rule
            2. Under Host and path rules, select the backend service that was created for Backend 1 *
            3. Under Host and path rules, click the trash can icon (Delete item) next to Backend 2 *
            4. Click Create
    
    - Test global external Application Load Balancer
        * Click on load balancer once it is done initializing
        * Copy the value under IP:Port (e.g., 8.233.227.121:80)
        * Open a new tab in your browser and paste the copied value under IP:Port in the address bar
        * Once the webpage is rendered, manually refresh the browser. If you see different values for Zone then you have successfully configured a global external Application Load Balancer