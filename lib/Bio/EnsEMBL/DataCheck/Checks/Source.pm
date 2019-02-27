=head1 LICENSE

Copyright [2018-2019] EMBL-European Bioinformatics Institute

Licensed under the Apache License, Version 2.0 (the 'License');
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an 'AS IS' BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

=cut

package Bio::EnsEMBL::DataCheck::Checks::Source;

use warnings;
use strict;

use Moose;
use Test::More;
use Bio::EnsEMBL::DataCheck::Test::DataCheck;

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'Source',
  DESCRIPTION => 'Source table is consistent',
  DB_TYPES    => ['variation'],
  TABLES      => ['source']
};

sub tests {
  my ($self) = @_;

  my $desc_url = 'Source URL consistent'; 
  my $diag_url = 'Source URL not consistent'; 
  my $sql_url = qq/
      SELECT * 
      FROM source
      WHERE url NOT REGEXP '^http[s]?:\/\/.*';    
  /;
  is_rows_zero($self->dba, $sql_url, $desc_url, $diag_url); 

  my $desc_name = 'Source name duplicated';
  my $diag_name = 'Source name is duplicated'; 
  my $sql_name = qq/
      SELECT *
      FROM source s1, source s2 
      WHERE s1.name = s2.name 
      AND s1.source_id < s2.source_id 
  /;
  is_rows_zero($self->dba, $sql_name, $desc_name, $diag_name); 

}

1;

