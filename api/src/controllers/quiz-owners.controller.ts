import {
  Count,
  CountSchema,
  Filter,
  FilterExcludingWhere,
  repository,
  Where,
} from '@loopback/repository';
import {
  post,
  param,
  get,
  getModelSchemaRef,
  patch,
  put,
  del,
  requestBody,
} from '@loopback/rest';
import {QuizOwners} from '../models';
import {QuizOwnersRepository} from '../repositories';

export class QuizOwnersController {
  constructor(
    @repository(QuizOwnersRepository)
    public quizOwnersRepository: QuizOwnersRepository,
  ) {}

  @post('/quiz-owners', {
    responses: {
      '200': {
        description: 'QuizOwners model instance',
        content: {'application/json': {schema: getModelSchemaRef(QuizOwners)}},
      },
    },
  })
  async create(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(QuizOwners, {
            title: 'NewQuizOwners',
            exclude: ['id'],
          }),
        },
      },
    })
    quizOwners: Omit<QuizOwners, 'id'>,
  ): Promise<QuizOwners> {
    return this.quizOwnersRepository.create(quizOwners);
  }

  @get('/quiz-owners/count', {
    responses: {
      '200': {
        description: 'QuizOwners model count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async count(
    @param.where(QuizOwners) where?: Where<QuizOwners>,
  ): Promise<Count> {
    return this.quizOwnersRepository.count(where);
  }

  @get('/quiz-owners', {
    responses: {
      '200': {
        description: 'Array of QuizOwners model instances',
        content: {
          'application/json': {
            schema: {
              type: 'array',
              items: getModelSchemaRef(QuizOwners, {includeRelations: true}),
            },
          },
        },
      },
    },
  })
  async find(
    @param.filter(QuizOwners) filter?: Filter<QuizOwners>,
  ): Promise<QuizOwners[]> {
    return this.quizOwnersRepository.find(filter);
  }

  @patch('/quiz-owners', {
    responses: {
      '200': {
        description: 'QuizOwners PATCH success count',
        content: {'application/json': {schema: CountSchema}},
      },
    },
  })
  async updateAll(
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(QuizOwners, {partial: true}),
        },
      },
    })
    quizOwners: QuizOwners,
    @param.where(QuizOwners) where?: Where<QuizOwners>,
  ): Promise<Count> {
    return this.quizOwnersRepository.updateAll(quizOwners, where);
  }

  @get('/quiz-owners/{id}', {
    responses: {
      '200': {
        description: 'QuizOwners model instance',
        content: {
          'application/json': {
            schema: getModelSchemaRef(QuizOwners, {includeRelations: true}),
          },
        },
      },
    },
  })
  async findById(
    @param.path.number('id') id: number,
    @param.filter(QuizOwners, {exclude: 'where'})
    filter?: FilterExcludingWhere<QuizOwners>,
  ): Promise<QuizOwners> {
    return this.quizOwnersRepository.findById(id, filter);
  }

  @patch('/quiz-owners/{id}', {
    responses: {
      '204': {
        description: 'QuizOwners PATCH success',
      },
    },
  })
  async updateById(
    @param.path.number('id') id: number,
    @requestBody({
      content: {
        'application/json': {
          schema: getModelSchemaRef(QuizOwners, {partial: true}),
        },
      },
    })
    quizOwners: QuizOwners,
  ): Promise<void> {
    await this.quizOwnersRepository.updateById(id, quizOwners);
  }

  @put('/quiz-owners/{id}', {
    responses: {
      '204': {
        description: 'QuizOwners PUT success',
      },
    },
  })
  async replaceById(
    @param.path.number('id') id: number,
    @requestBody() quizOwners: QuizOwners,
  ): Promise<void> {
    await this.quizOwnersRepository.replaceById(id, quizOwners);
  }

  @del('/quiz-owners/{id}', {
    responses: {
      '204': {
        description: 'QuizOwners DELETE success',
      },
    },
  })
  async deleteById(@param.path.number('id') id: number): Promise<void> {
    await this.quizOwnersRepository.deleteById(id);
  }
}
