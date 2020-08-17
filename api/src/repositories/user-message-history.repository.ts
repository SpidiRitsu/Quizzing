import {
  DefaultCrudRepository,
  repository,
  BelongsToAccessor,
} from '@loopback/repository';
import {
  UserMessageHistory,
  UserMessageHistoryRelations,
  Users,
} from '../models';
import {MySqlDataSource} from '../datasources';
import {inject, Getter} from '@loopback/core';
import {UsersRepository} from './users.repository';

export class UserMessageHistoryRepository extends DefaultCrudRepository<
  UserMessageHistory,
  typeof UserMessageHistory.prototype.id,
  UserMessageHistoryRelations
> {
  public readonly sender: BelongsToAccessor<
    Users,
    typeof UserMessageHistory.prototype.id
  >;

  public readonly receiver: BelongsToAccessor<
    Users,
    typeof UserMessageHistory.prototype.id
  >;

  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource,
    @repository.getter('UsersRepository')
    protected usersRepositoryGetter: Getter<UsersRepository>,
  ) {
    super(UserMessageHistory, dataSource);
    this.receiver = this.createBelongsToAccessorFor('receiver', usersRepositoryGetter);
    this.registerInclusionResolver('receiver', this.receiver.inclusionResolver);
    this.sender = this.createBelongsToAccessorFor('sender', usersRepositoryGetter);
    this.registerInclusionResolver('sender', this.sender.inclusionResolver);
  }
}
