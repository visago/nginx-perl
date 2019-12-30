#
# Test functions for use with Nginx Perl
#
# Has support for Cloudflare variables
#

package NginxTest;
use nginx;

sub debug {
    my $r = shift;
    $r->send_http_header("text/plain");
    return OK if $r->header_only;
    my $ip=$r->header_in("CF-Connecting-IP") || $r->header_in("X-Forwarded-For") || $r->remote_addr;
    foreach my $k ("Host","X-Forwarded-For","X-Forwarded-Proto","True-Client-IP","CF-Connecting-IP","CF-RAY","Cf-Access-Authenticated-User-Email","CF-IPCountry","Forwarded","CDN-Loop","Cf-Pseudo-IPv4","Cf-Connecting-IPv6") {
      if ($r->header_in($k)) {
        $r->print(sprintf("%s=%s\n",$k,$r->header_in($k) || ""));
      }
    }
    $r->print(sprintf("%s=%s\n","request_method",$r->request_method));
    $r->print(sprintf("%s=%s\n","remote_addr",$r->remote_addr));
    $r->print(sprintf("%s=%s\n","ip",$ip));
    $r->print("\n");
    if ($r->args) {
      my $params=parse_query($r->args);
      foreach my $k (keys %{$params}) {
        $r->print(sprintf("%s=%s\n",$k,$params->{$k}));
      }
    }
    return OK;
}

sub cfadmin { 
    my $r = shift;
    $r->send_http_header("text/html");
    return OK if $r->header_only;
    my $ip=$r->header_in("CF-Connecting-IP") || $r->header_in("X-Forwarded-For") || $r->remote_addr;
    $r->print("<html><body>\n");
    $r->print("<br><h1>Admin Page</h1>\n");
    $r->print(sprintf("Welcome user %s of IP %s to the fake admin page<br>\n",$r->header_in("Cf-Access-Authenticated-User-Email"),$ip));
    $r->print("</body></html>\n");

    return OK;
}

sub ip {
    my $r = shift;
    $r->send_http_header("text/plain");
    return OK if $r->header_only;
    my $now = localtime(time());
    my $ip=$r->header_in("CF-Connecting-IP") || $r->header_in("X-Forwarded-For") || $r->remote_addr;
    $r->print(sprintf("%s",$ip));
    return OK;
}

sub parse_query {
   my ( $query) = @_;
   my $params;
   foreach $var ( split( /&/, $query ) ){
     my ( $k, $v ) = split( /=/, $var );
     $k = uri_unescape $k;
     $v = uri_unescape $v;
     if( exists $params->{$k} ) {
        if( 'ARRAY' eq ref $params->{$k} ) {
           push @{ $params->{$k} }, $v;
        } else {
           $params->{$k} = [ $params->{$k}, $v ];
        }
     } else {
        $params->{$k} = $v;
     }
   }
   return $params;
}

sub uri_unescape {
    # Note from RFC1630:  "Sequences which start with a percent sign
    # but are not followed by two hexadecimal characters are reserved
    # for future extension"
    my $str = shift;
    if (@_ && wantarray) {
        # not executed for the common case of a single argument
        my @str = ($str, @_);  # need to copy
        for (@str) {
            s/%([0-9A-Fa-f]{2})/chr(hex($1))/eg;
        }
        return @str;
    }
    $str =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/eg if defined $str;
    $str;
}


1;
__END__
