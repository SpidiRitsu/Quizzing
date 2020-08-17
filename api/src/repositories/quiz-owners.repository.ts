import {
  DefaultCrudRepository,
  repository,
  BelongsToAccessor,
} from '@loopback/repository';
import {QuizOwners, QuizOwnersRelations, Users} from '../models';
import {MySqlDataSource} from '../datasources';
import {inject, Getter} from '@loopback/core';
import {UsersRepository} from './users.repository';

export class QuizOwnersRepository extends DefaultCrudRepository<
  QuizOwners,
  typeof QuizOwners.prototype.id,
  QuizOwnersRelations
> {
  public readonly owner: BelongsToAccessor<
    Users,
    typeof QuizOwners.prototype.id
  >;

  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource,
    @repository.getter('UsersRepository')
    protected usersRepositoryGetter: Getter<UsersRepository>,
  ) {
    super(QuizOwners, dataSource);
    this.owner = this.createBelongsToAccessorFor(
      'owner',
      usersRepositoryGetter,
    );
    this.registerInclusionResolver('owner', this.owner.inclusionResolver);
  }
}
