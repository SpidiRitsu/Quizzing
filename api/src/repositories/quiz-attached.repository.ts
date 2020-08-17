import {
  DefaultCrudRepository,
  repository,
  BelongsToAccessor,
} from '@loopback/repository';
import {
  QuizAttached,
  QuizAttachedRelations,
  Users,
  QuizOwners,
} from '../models';
import {MySqlDataSource} from '../datasources';
import {inject, Getter} from '@loopback/core';
import {UsersRepository} from './users.repository';
import {QuizOwnersRepository} from './quiz-owners.repository';

export class QuizAttachedRepository extends DefaultCrudRepository<
  QuizAttached,
  typeof QuizAttached.prototype.id,
  QuizAttachedRelations
> {
  public readonly user: BelongsToAccessor<
    Users,
    typeof QuizAttached.prototype.id
  >;

  public readonly quiz: BelongsToAccessor<
    QuizOwners,
    typeof QuizAttached.prototype.id
  >;

  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource,
    @repository.getter('UsersRepository')
    protected usersRepositoryGetter: Getter<UsersRepository>,
    @repository.getter('QuizOwnersRepository')
    protected quizOwnersRepositoryGetter: Getter<QuizOwnersRepository>,
  ) {
    super(QuizAttached, dataSource);
    this.quiz = this.createBelongsToAccessorFor(
      'quiz',
      quizOwnersRepositoryGetter,
    );
    this.registerInclusionResolver('quiz', this.quiz.inclusionResolver);
    this.user = this.createBelongsToAccessorFor('user', usersRepositoryGetter);
    this.registerInclusionResolver('user', this.user.inclusionResolver);
  }
}
