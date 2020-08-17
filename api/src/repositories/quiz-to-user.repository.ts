import {
  DefaultCrudRepository,
  repository,
  BelongsToAccessor,
} from '@loopback/repository';
import {QuizToUser, QuizToUserRelations, Users, QuizOwners} from '../models';
import {MySqlDataSource} from '../datasources';
import {inject, Getter} from '@loopback/core';
import {UsersRepository} from './users.repository';
import {QuizOwnersRepository} from './quiz-owners.repository';

export class QuizToUserRepository extends DefaultCrudRepository<
  QuizToUser,
  typeof QuizToUser.prototype.quizId,
  QuizToUserRelations
> {
  public readonly user: BelongsToAccessor<
    Users,
    typeof QuizToUser.prototype.quizId
  >;

  public readonly quiz: BelongsToAccessor<
    QuizOwners,
    typeof QuizToUser.prototype.quizId
  >;

  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource,
    @repository.getter('UsersRepository')
    protected usersRepositoryGetter: Getter<UsersRepository>,
    @repository.getter('QuizOwnersRepository')
    protected quizOwnersRepositoryGetter: Getter<QuizOwnersRepository>,
  ) {
    super(QuizToUser, dataSource);
    this.quiz = this.createBelongsToAccessorFor(
      'quiz',
      quizOwnersRepositoryGetter,
    );
    this.registerInclusionResolver('quiz', this.quiz.inclusionResolver);
    this.user = this.createBelongsToAccessorFor('user', usersRepositoryGetter);
    this.registerInclusionResolver('user', this.user.inclusionResolver);
  }
}
