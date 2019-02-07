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

extends 'Bio::EnsEMBL::DataCheck::DbCheck';

use constant {
  NAME        => 'Source',
  DESCRIPTION => 'Checks that the source table is consistent',
  DB_TYPES    => ['variation'],
  TABLES      => ['source']
};

sub tests {
  my ($self) = @_;

  my $desc_length = 'dbSNP sources version'; 
  my $diag_length = "Different versions set for dbSNP sources";
  my $sql_length = qq/
      SELECT COUNT(DISTINCT version)
      FROM source
      WHERE name like '%dbSNP%'
  /; 
  cmp_rows($self->dba, $sql_length, '<=', 1, $desc_length); 

  my $desc_length_2 = 'Source description';
  my $diag_length_2 = "Source description is missing"; 
  my $sql_length_2 = qq/
      SELECT count(*)
      FROM source
      WHERE description IS NULL
      or description = 'NULL'
  /;
  is_rows_zero($self->dba, $sql_length_2, $desc_length_2, $diag_length_2); 

  my $desc_length_3 = 'Source description';
  my $diag_length_3 = "Variation sources have long descriptions"; 
  my $sql_length_3 = qq/
      SELECT count(*)
      FROM source
      WHERE length(description) > 100 
      and data_types = 'variation'
  /;
  is_rows_zero($self->dba, $sql_length_3, $desc_length_3, $diag_length_3); 

}

1;

