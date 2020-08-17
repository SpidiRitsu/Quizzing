import {
  DefaultCrudRepository,
  repository,
  BelongsToAccessor,
} from '@loopback/repository';
import {Questions, QuestionsRelations, QuizOwners} from '../models';
import {MySqlDataSource} from '../datasources';
import {inject, Getter} from '@loopback/core';
import {QuizOwnersRepository} from './quiz-owners.repository';

export class QuestionsRepository extends DefaultCrudRepository<
  Questions,
  typeof Questions.prototype.id,
  QuestionsRelations
> {
  public readonly quiz: BelongsToAccessor<
    QuizOwners,
    typeof Questions.prototype.id
  >;

  constructor(
    @inject('datasources.MySQL') dataSource: MySqlDataSource,
    @repository.getter('QuizOwnersRepository')
    protected quizOwnersRepositoryGetter: Getter<QuizOwnersRepository>,
  ) {
    super(Questions, dataSource);
    this.quiz = this.createBelongsToAccessorFor(
      'quiz',
      quizOwnersRepositoryGetter,
    );
    this.registerInclusionResolver('quiz', this.quiz.inclusionResolver);
  }
}
